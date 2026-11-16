import 'package:notes/features/auth/data/auth_repository.dart';
import 'package:notes/features/notes/data/notes_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logout_usecase.g.dart';

class UnsyncedSummary {
  final bool hasUnsyncedAccount;
  final int unsyncedNotesCount;

  const UnsyncedSummary({
    required this.hasUnsyncedAccount,
    required this.unsyncedNotesCount,
  });

  bool get hasAnyUnsynced => hasUnsyncedAccount || unsyncedNotesCount > 0;
}

/// ============================================================================
/// ARCHITECTURAL NOTE — Cross-Repository Orchestration (LogoutUseCase)
/// ============================================================================
/// Logging out in an offline-first app isn't just `prefs.clear()`.
/// It coordinates `AuthRepository` and `NotesRepository` to prevent data loss:
/// 1. Checks whether the local account or any notes are still unsynced.
/// 2. Supports `syncAndSignOut()` which force-syncs account + dirty notes
///    before clearing the local session—aborting if the device is offline.
class LogoutUseCase {
  final AuthRepository authRepository;
  final NotesRepository notesRepository;

  const LogoutUseCase({
    required this.authRepository,
    required this.notesRepository,
  });

  Future<UnsyncedSummary> checkUnsyncedData() async {
    final user = await authRepository.getCurrentUser();
    if (user == null) {
      return const UnsyncedSummary(
        hasUnsyncedAccount: false,
        unsyncedNotesCount: 0,
      );
    }

    final unsyncedNotes = await notesRepository.getUnsyncedCount(user.id);
    return UnsyncedSummary(
      hasUnsyncedAccount: user.syncStatus.needsSync,
      unsyncedNotesCount: unsyncedNotes,
    );
  }

  /// Force-syncs local account + all pending notes, then signs out.
  /// Throws [NetworkException] if offline so no data is lost.
  Future<void> syncAndSignOut() async {
    final user = await authRepository.getCurrentUser();
    if (user != null) {
      if (user.syncStatus.needsSync) {
        await authRepository.syncPendingAccountStrict();
      }
      await notesRepository.syncPendingNotes(user.id, throwOnError: true);
    }
    await authRepository.signOut();
  }

  /// Signs out immediately without syncing.
  Future<void> forceSignOut() async {
    await authRepository.signOut();
  }
}

@riverpod
LogoutUseCase logoutUseCase(Ref ref) {
  return LogoutUseCase(
    authRepository: ref.watch(authRepositoryProvider),
    notesRepository: ref.watch(notesRepositoryProvider),
  );
}
