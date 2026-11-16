# AGENTS.md — Architectural & Engineering Guidelines

This document defines the architectural standards, conventions, and engineering principles for the **Notes** offline-first application. Any AI agent or contributor working on this codebase must adhere to these guidelines.

---

## 1. Architectural Philosophy: Feature-First Reactive Architecture (Pragmatic Clean)

We follow a **Pragmatic Clean Architecture** tailored for **Offline-First Reactive Flutter** applications:

1. **Single Source of Truth (SSOT)**:
   - The local **Drift (SQLite)** database is the single source of truth.
   - The UI **never** awaits or renders network responses directly for persistent domain data.
   - Network responses from **Retrofit / Dio** are written into Drift, and the UI reacts automatically via Drift's reactive `Stream` queries exposed through **Riverpod**.

2. **Pragmatic Layering (No Ceremonial Boilerplate)**:
   - **Direct Reactive Reads**: For queries (`Stream` / `Future` reads without business logic), Presentation Controllers/Providers subscribe directly to the `Repository`. Do **not** create pass-through UseCases (`GetNotesUseCase` that only calls `repo.watchNotes()`).
   - **UseCases for Mutations & Orchestration**: Introduce a `UseCase` in the `application/` layer **only** when there is business validation, domain invariants (e.g., stamping timestamps, marking `SyncStatus`), or multi-repository orchestration (e.g., local DB write + outbox sync queue + analytics/notifications).
   - **Unified Models over Mapper Bloat**: Use `dart_mappable` on domain models rather than maintaining duplicate Entity / DTO / UI-Model classes when schemas align.
   - **Concrete Repositories by Default**: Do not create `abstract class FooRepository` + `FooRepositoryImpl` unless multiple runtime implementations actually exist. In Riverpod, any concrete class provided via a `Provider` can be mocked or overridden in tests via `providerScope.overrides`.

---

## 2. Tech Stack & Responsibilities

| Concern | Package | Responsibility |
| :--- | :--- | :--- |
| **State Management & DI** | `hooks_riverpod`, `riverpod_annotation` | Reactive dependency injection, caching, stream binding, and UI controllers (`AsyncNotifier`). |
| **Ephemeral Widget State** | `flutter_hooks` | Local widget lifecycle state (`useTextEditingController`, `useFocusNode`, `useAnimationController`). |
| **Local Database (SSOT)** | `drift`, `drift_flutter` | Local SQLite storage, reactive table streams, DAOs, and offline persistence (including Auth sessions). |
| **Remote Networking** | `retrofit`, `dio` | Type-safe REST API clients, auth token interceptors, and background cloud synchronization. |
| **Data Modeling** | `dart_mappable` | Immutable models, `copyWith`, value equality, and JSON serialization. |
| **Routing & Deep Links** | `auto_route` | Declarative routing, auth route guards, and deep-linking support. |
| **Assets & Vectors** | `flutter_svg` | SVG vector rendering from `assets/vectors/` and custom typography (`FugazOne`). |

---

## 3. Directory Structure

```text
lib/
├── main.dart                          # Entry point with ProviderScope
├── app/
│   ├── app.dart                       # Root MaterialApp.router configuration
│   ├── router/
│   │   ├── app_router.dart            # AutoRoute definitions & deep-link config
│   │   └── auth_guard.dart            # Route guard checking auth state
│   └── theme/
│       └── app_theme.dart             # App typography (FugazOne) and color scheme
├── core/
│   ├── database/
│   │   ├── app_database.dart          # Drift database & table registration
│   │   └── tables/                    # SQLite table schemas
│   ├── error/
│   │   └── app_exception.dart         # Sealed/typed domain & network exceptions
│   ├── network/
│   │   ├── api_endpoints.dart         # Base URLs and endpoint paths
│   │   └── dio_client.dart            # Configured Dio instance + interceptors
│   └── sync/
│       └── sync_status.dart           # Offline synchronization status enum
└── features/
    ├── auth/
    │   ├── domain/                    # AuthUser model & auth state types
    │   ├── data/
    │   │   ├── local/                 # AuthLocalDao (Drift session persistence)
    │   │   ├── remote/                # AuthRemoteApi (Retrofit client)
    │   │   └── auth_repository.dart   # Coordinates token/session persistence
    │   ├── application/               # LoginUseCase / LogoutUseCase (validation & orchestration)
    │   └── presentation/
    │       ├── controllers/           # AuthController (AsyncNotifier)
    │       └── screens/               # LoginScreen (HookConsumerWidget)
    └── notes/
        ├── domain/                    # Note model
        ├── data/
        │   ├── local/                 # NotesLocalDao (Drift reactive queries)
        │   ├── remote/                # NotesRemoteApi (Retrofit sync endpoints)
        │   └── notes_repository.dart  # Offline-first CRUD & background sync
        ├── application/               # SaveNoteUseCase / DeleteNoteUseCase
        └── presentation/
            ├── controllers/           # NotesStreamProvider & NoteEditorController
            └── screens/               # NotesListScreen & NoteEditorScreen
```

---

## 4. Coding Rules for Agents

1. **No Business Logic in Widgets**: Widgets (`HookConsumerWidget`) only render state and dispatch intentions to Riverpod `AsyncNotifier` controllers.
2. **No UI Logic in UseCases**: UseCases must never import `package:flutter/material.dart` or manage loading states. They are pure Dart classes.
3. **Offline-First Writes**: Every user mutation on notes must write to the local Drift database first with a dirty `SyncStatus` (`pendingCreate`, `pendingUpdate`, `pendingDelete`) so the UI updates instantaneously offline, then trigger non-blocking background synchronization.
4. **Primary Constructors & Global `dart_mappable` Parser**:
   - Define `@MappableClass()` models using **Dart Primary Constructors** (`class Note({required final String id, ...}) with NoteMappable;`).
   - Do **not** add manual `fromJson` / `toJson` methods to models or repeat `parser: Parser.DartMappable` on `@RestApi()` classes—`build.yaml` already sets `parser: dart_mappable` globally for `retrofit_generator` (PR #939).
5. **Code Generation**: When modifying files with `@riverpod`, `@MappableClass`, `@RestApi`, `@AutoRouterConfig`, or Drift tables, run:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

