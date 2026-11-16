import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notes/app/router/app_router.dart';
import 'package:notes/features/auth/presentation/controllers/auth_controller.dart';

/// ============================================================================
/// ARCHITECTURAL NOTE — HookConsumerWidget (Hooks + Riverpod in UI)
/// ============================================================================
/// Coming from `StatefulWidget` + `BlocConsumer`:
/// 1. `useTextEditingController()` (from `flutter_hooks`) creates AND automatically
///    disposes the controller when the widget unmounts—no `initState` or `dispose()`!
/// 2. `ref.listen(...)` is your `BlocListener` (for side-effects like SnackBars
///    and navigation).
/// 3. `ref.watch(...)` is your `BlocBuilder` (for rebuilding UI when state changes).
@RoutePage()
class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController(text: 'demo@notes.app');
    final passwordController = useTextEditingController(text: 'password123');

    // Equivalent to `BlocBuilder`: watches the controller's AsyncValue<void>
    final authActionState = ref.watch(authControllerProvider);

    // Equivalent to `BlocListener`: listens for errors to show a SnackBar
    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SvgPicture.asset(
                    'assets/vectors/amico.svg',
                    height: 180,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Notes',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontFamily: 'FugazOne',
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Offline-First Architecture Scaffold',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: authActionState.isLoading
                        ? null
                        : () async {
                            final success = await ref
                                .read(authControllerProvider.notifier)
                                .signIn(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                            if (success && context.mounted) {
                              context.router.replaceAll([const NotesListRoute()]);
                            }
                          },
                    child: authActionState.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Sign In'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

