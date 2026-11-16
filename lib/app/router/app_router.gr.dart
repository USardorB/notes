// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AboutScreen]
class AboutRoute extends PageRouteInfo<void> {
  const AboutRoute({List<PageRouteInfo>? children})
    : super(AboutRoute.name, initialChildren: children);

  static const String name = 'AboutRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AboutScreen();
    },
  );
}

/// generated route for
/// [CreateAccountScreen]
class CreateAccountRoute extends PageRouteInfo<void> {
  const CreateAccountRoute({List<PageRouteInfo>? children})
    : super(CreateAccountRoute.name, initialChildren: children);

  static const String name = 'CreateAccountRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CreateAccountScreen();
    },
  );
}

/// generated route for
/// [ForgotPasswordScreen]
class ForgotPasswordRoute extends PageRouteInfo<void> {
  const ForgotPasswordRoute({List<PageRouteInfo>? children})
    : super(ForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgotPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ForgotPasswordScreen();
    },
  );
}

/// generated route for
/// [LegalDocumentScreen]
class LegalDocumentRoute extends PageRouteInfo<LegalDocumentRouteArgs> {
  LegalDocumentRoute({
    Key? key,
    required LegalDocumentType type,
    List<PageRouteInfo>? children,
  }) : super(
         LegalDocumentRoute.name,
         args: LegalDocumentRouteArgs(key: key, type: type),
         initialChildren: children,
       );

  static const String name = 'LegalDocumentRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LegalDocumentRouteArgs>();
      return LegalDocumentScreen(key: args.key, type: args.type);
    },
  );
}

class LegalDocumentRouteArgs {
  const LegalDocumentRouteArgs({this.key, required this.type});

  final Key? key;

  final LegalDocumentType type;

  @override
  String toString() {
    return 'LegalDocumentRouteArgs{key: $key, type: $type}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LegalDocumentRouteArgs) return false;
    return key == other.key && type == other.type;
  }

  @override
  int get hashCode => key.hashCode ^ type.hashCode;
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginScreen();
    },
  );
}

/// generated route for
/// [MainShellScreen]
class MainShellRoute extends PageRouteInfo<MainShellRouteArgs> {
  MainShellRoute({Key? key, String? tab, List<PageRouteInfo>? children})
    : super(
        MainShellRoute.name,
        args: MainShellRouteArgs(key: key, tab: tab),
        rawQueryParams: {'tab': tab},
        initialChildren: children,
      );

  static const String name = 'MainShellRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<MainShellRouteArgs>(
        orElse: () => MainShellRouteArgs(tab: queryParams.optString('tab')),
      );
      return MainShellScreen(key: args.key, tab: args.tab);
    },
  );
}

class MainShellRouteArgs {
  const MainShellRouteArgs({this.key, this.tab});

  final Key? key;

  final String? tab;

  @override
  String toString() {
    return 'MainShellRouteArgs{key: $key, tab: $tab}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MainShellRouteArgs) return false;
    return key == other.key && tab == other.tab;
  }

  @override
  int get hashCode => key.hashCode ^ tab.hashCode;
}

/// generated route for
/// [NoteEditorScreen]
class NoteEditorRoute extends PageRouteInfo<NoteEditorRouteArgs> {
  NoteEditorRoute({Key? key, Note? existingNote, List<PageRouteInfo>? children})
    : super(
        NoteEditorRoute.name,
        args: NoteEditorRouteArgs(key: key, existingNote: existingNote),
        initialChildren: children,
      );

  static const String name = 'NoteEditorRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NoteEditorRouteArgs>(
        orElse: () => const NoteEditorRouteArgs(),
      );
      return NoteEditorScreen(key: args.key, existingNote: args.existingNote);
    },
  );
}

class NoteEditorRouteArgs {
  const NoteEditorRouteArgs({this.key, this.existingNote});

  final Key? key;

  final Note? existingNote;

  @override
  String toString() {
    return 'NoteEditorRouteArgs{key: $key, existingNote: $existingNote}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NoteEditorRouteArgs) return false;
    return key == other.key && existingNote == other.existingNote;
  }

  @override
  int get hashCode => key.hashCode ^ existingNote.hashCode;
}

/// generated route for
/// [OnboardingScreen]
class OnboardingRoute extends PageRouteInfo<void> {
  const OnboardingRoute({List<PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnboardingScreen();
    },
  );
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashScreen();
    },
  );
}

/// generated route for
/// [TodoEditorScreen]
class TodoEditorRoute extends PageRouteInfo<TodoEditorRouteArgs> {
  TodoEditorRoute({Key? key, Note? existingNote, List<PageRouteInfo>? children})
    : super(
        TodoEditorRoute.name,
        args: TodoEditorRouteArgs(key: key, existingNote: existingNote),
        initialChildren: children,
      );

  static const String name = 'TodoEditorRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TodoEditorRouteArgs>(
        orElse: () => const TodoEditorRouteArgs(),
      );
      return TodoEditorScreen(key: args.key, existingNote: args.existingNote);
    },
  );
}

class TodoEditorRouteArgs {
  const TodoEditorRouteArgs({this.key, this.existingNote});

  final Key? key;

  final Note? existingNote;

  @override
  String toString() {
    return 'TodoEditorRouteArgs{key: $key, existingNote: $existingNote}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TodoEditorRouteArgs) return false;
    return key == other.key && existingNote == other.existingNote;
  }

  @override
  int get hashCode => key.hashCode ^ existingNote.hashCode;
}
