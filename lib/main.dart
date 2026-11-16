import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notes/app/app.dart';

/// ============================================================================
/// ARCHITECTURAL NOTE — ProviderScope vs MultiBlocProvider + GetIt
/// ============================================================================
/// Coming from Bloc + GetIt:
/// You don't need `await setupServiceLocator()` or a giant `MultiBlocProvider`
/// tree at the root of your app.
///
/// `ProviderScope` is the single container that lazily initializes, caches, and
/// disposes every Riverpod provider (Database, Dio, Repositories, UseCases, and
/// UI Controllers) on demand!
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: NotesApp(),
    ),
  );
}
