import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notes/app/router/app_router.dart';
import 'package:notes/app/theme/app_theme.dart';
import 'package:notes/features/auth/presentation/widgets/habit_logo_mark.dart';

class _OnboardingSlideData {
  final String assetPath;
  final String title;
  final String subtitle;
  final bool showWelcomeHeader;

  const _OnboardingSlideData({
    required this.assetPath,
    required this.title,
    required this.subtitle,
    this.showWelcomeHeader = false,
  });
}

const _slides = <_OnboardingSlideData>[
  _OnboardingSlideData(
    assetPath: 'assets/vectors/amico copy.svg',
    title: 'Take Notes',
    subtitle: 'Quickly capture what’s on your mind',
    showWelcomeHeader: true,
  ),
  _OnboardingSlideData(
    assetPath: 'assets/vectors/cuate.svg',
    title: 'To-dos',
    subtitle: 'List out your day-to-day tasks',
  ),
  _OnboardingSlideData(
    assetPath: 'assets/vectors/amico.svg',
    title: 'Image to Text Converter',
    subtitle: 'Upload your images and convert to text',
  ),
];

@RoutePage()
class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final currentPage = useState(0);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const _HabitDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Bar (Hamburger Menu Icon opens Material Drawer)
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 12, right: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Builder(
                  builder: (scaffoldContext) => HabitHamburgerButton(
                    onTap: () => Scaffold.of(scaffoldContext).openDrawer(),
                  ),
                ),
              ),
            ),

            // Swipeable Onboarding Carousel
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: _slides.length,
                onPageChanged: (index) => currentPage.value = index,
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header ("WELCOME TO / HaBIT Note" on first slide,
                        // matching vertical spacing across slides)
                        SizedBox(
                          height: 68,
                          child: slide.showWelcomeHeader
                              ? const Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'WELCOME TO',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black87,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'HaBIT Note',
                                        style: TextStyle(
                                          fontFamily: 'FugazOne',
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : null,
                        ),

                        // Vector Illustration
                        Expanded(
                          child: Center(
                            child: SvgPicture.asset(
                              slide.assetPath,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Slide Title & Subtitle
                        Text(
                          slide.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          slide.subtitle,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Page Indicator Pills
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (index) {
                final isSelected = currentPage.value == index;
                return GestureDetector(
                  onTap: () => pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    height: 14,
                    width: isSelected ? 62 : 32,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 32),

            // CREATE ACCOUNT & LOG IN Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HabitPillButton(
                    label: 'CREATE ACCOUNT',
                    backgroundColor: AppColors.primary,
                    textColor: Colors.white,
                    onPressed: () =>
                        context.router.push(const CreateAccountRoute()),
                  ),
                  const SizedBox(height: 18),
                  _HabitPillButton(
                    label: 'LOG IN',
                    backgroundColor: Colors.white,
                    textColor: AppColors.primary,
                    onPressed: () => context.router.push(const LoginRoute()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HabitPillButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  const _HabitPillButton({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onPressed,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 15.5,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Material `Drawer` matching the 3rd reference screen (`HaBIT Note V1.0.0`,
/// Forgot Password, Privacy Policy, Terms of Use, with vertical amber gradient).
class _HabitDrawer extends StatelessWidget {
  const _HabitDrawer();

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
              // Top Hamburger Icon
              Padding(
                padding: const EdgeInsets.only(left: 28, top: 16),
                child: HabitHamburgerButton(
                  width: 28,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(height: 28),

              // Brand Title & Version
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

              // Full-width thin horizontal line
              const Divider(
                color: Colors.black54,
                thickness: 1,
                height: 1,
              ),
              const SizedBox(height: 24),

              // Menu items
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
