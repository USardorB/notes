import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:notes/app/router/app_router.dart';
import 'package:notes/app/theme/app_theme.dart';
import 'package:notes/features/auth/presentation/widgets/habit_logo_mark.dart';

/// Material `Drawer` (`HaBIT Note V1.0.0`, Forgot Password, Privacy Policy,
/// Terms of Use, with vertical amber gradient).
class HabitDrawer extends StatelessWidget {
  const HabitDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    const leftIndent = 44.0;

    return Drawer(
      shape: const RoundedRectangleBorder(),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.20, 0.55, 1.0],
            colors: [
              Color(0xFFF3F3F3),
              Color(0xFFF7F4EE),
              Color(0xFFFCE2B6),
              AppColors.primary,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 28, top: 16),
                child: HabitHamburgerButton(
                  width: 28,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(height: 28),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: leftIndent),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HaBIT Note',
                      style: TextStyle(
                        fontFamily: 'FugazOne',
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'V1.0.0',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Divider(
                color: Colors.black54,
                thickness: 1,
                height: 1,
              ),
              const SizedBox(height: 24),
              _MenuLinkItem(
                title: 'Forgot Password',
                leftIndent: leftIndent,
                onTap: () {
                  Navigator.of(context).pop();
                  context.router.push(const ForgotPasswordRoute());
                },
              ),
              _MenuLinkItem(
                title: 'Privacy Policy',
                leftIndent: leftIndent,
                onTap: () => Navigator.of(context).pop(),
              ),
              _MenuLinkItem(
                title: 'Terms of Use',
                leftIndent: leftIndent,
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuLinkItem extends StatelessWidget {
  final String title;
  final double leftIndent;
  final VoidCallback onTap;

  const _MenuLinkItem({
    required this.title,
    required this.leftIndent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: leftIndent,
          vertical: 14,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
