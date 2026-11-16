import 'package:dio/dio.dart';
import 'package:notes/core/network/api_endpoints.dart';
import 'package:notes/core/network/dio_client.dart';
import 'package:notes/features/notes/domain/note.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notes_remote_api.g.dart';

/// Configured globally via `build.yaml` (`parser: dart_mappable` — PR #939).
@RestApi()
abstract class NotesRemoteApi {
  factory NotesRemoteApi(Dio dio, {String? baseUrl}) = _NotesRemoteApi;

  @GET(ApiEndpoints.notes)
  Future<List<Note>> fetchAllNotes();

  @POST(ApiEndpoints.notes)
  Future<Note> createNote(@Body() Note note);

  @PUT('${ApiEndpoints.notes}/{id}')
  Future<Note> updateNote(@Path('id') String id, @Body() Note note);

  @DELETE('${ApiEndpoints.notes}/{id}')
  Future<void> deleteNote(@Path('id') String id);
}

@riverpod
NotesRemoteApi notesRemoteApi(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return NotesRemoteApi(dio);
}
