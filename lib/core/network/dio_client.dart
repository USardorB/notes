import 'package:dio/dio.dart';
import 'package:notes/core/database/app_database.dart';
import 'package:notes/core/network/api_endpoints.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

/// ============================================================================
/// ARCHITECTURAL NOTE — Reactive HTTP Client & Token Injection
/// ============================================================================
/// In a traditional GetIt + SharedPreferences setup, an interceptor has to reach
/// into a global `SharedPreferences` instance to attach the Bearer token.
///
/// With Riverpod + Drift, our interceptor queries the local SQLite session
/// (or cached provider state) cleanly through Dependency Injection (`ref`).
@Riverpod(keepAlive: true)
Dio dioClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  final db = ref.watch(appDatabaseProvider);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Read current offline/local session token from Drift before sending request
        final session = await db.select(db.authSessions).getSingleOrNull();
        if (session != null && session.accessToken.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer ${session.accessToken}';
        }
        handler.next(options);
      },
    ),
  );

  return dio;
}

