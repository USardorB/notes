import 'package:dio/dio.dart';
import 'package:notes/core/network/api_endpoints.dart';
import 'package:notes/core/network/dio_client.dart';
import 'package:notes/features/auth/domain/auth_user.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_api.g.dart';

/// ============================================================================
/// ARCHITECTURAL NOTE — Declarative REST Client (Retrofit + Global Parser)
/// ============================================================================
/// Notice we just write `@RestApi()` without `parser: Parser.DartMappable`.
/// Because `build.yaml` configures `parser: dart_mappable` globally
/// (via `trevorwang/retrofit.dart` PR #939), `retrofit_generator` automatically
/// uses `AuthUserMapper.fromMap` and `request.toMap()` for all `@RestApi()`
/// clients across the project!
@RestApi()
abstract class AuthRemoteApi {
  factory AuthRemoteApi(Dio dio, {String? baseUrl}) = _AuthRemoteApi;

  @POST(ApiEndpoints.login)
  Future<AuthUser> login(@Body() LoginRequest request);

  @POST(ApiEndpoints.register)
  Future<AuthUser> register(@Body() RegisterRequest request);

  @POST(ApiEndpoints.forgotPassword)
  Future<void> forgotPassword(@Body() Map<String, dynamic> body);

  @POST(ApiEndpoints.logout)
  Future<void> logout();
}

@riverpod
AuthRemoteApi authRemoteApi(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return AuthRemoteApi(dio);
}
