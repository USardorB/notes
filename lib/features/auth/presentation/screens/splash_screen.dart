import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notes/app/router/app_router.dart';
import 'package:notes/app/theme/app_theme.dart';
import 'package:notes/core/l10n/app_texts.dart';
import 'package:notes/core/widgets/habit_logo_mark.dart';
import 'package:notes/features/auth/data/auth_repository.dart';

@RoutePage()
class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> navigateNext() async {
      final user = await ref.read(authRepositoryProvider).getCurrentUser();
      if (!context.mounted) return;
      if (user != null) {
        await context.router.replaceAll([MainShellRoute()]);
      } else {
        await context.router.replaceAll([const OnboardingRoute()]);
      }
    }

    useEffect(
      () {
        final timer = Timer(const Duration(seconds: 2), navigateNext);
        return timer.cancel;
      },
      const [],
    );

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: navigateNext,
        child: SafeArea(
          child: SizedBox.expand(
            child: Column(
              children: [
                const Spacer(flex: 5),
                const HabitSplashEmblem(size: 152),
                const SizedBox(height: 18),
                Text(
                  AppTexts.appName,
                  style: const TextStyle(
                    fontFamily: 'FugazOne',
                    fontSize: 24,
                    color: Colors.black,
                    letterSpacing: 0.3,
                  ),
                ),
                const Spacer(flex: 6),
                Padding(
                  padding: const EdgeInsets.only(bottom: 28),
                  child: Text(
                    AppTexts.copyright,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
