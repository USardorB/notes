import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notes/app/router/app_router.dart';
import 'package:notes/app/theme/app_theme.dart';
import 'package:notes/core/l10n/app_texts.dart';
import 'package:notes/core/l10n/locale_controller.dart';
import 'package:notes/core/widgets/habit_logo_mark.dart';
import 'package:notes/features/auth/presentation/widgets/habit_drawer.dart';

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

@RoutePage()
class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appLocaleProvider);
    final pageController = usePageController();
    final currentPage = useState(0);
    final colors = Theme.of(context).colorScheme;

    final slides = <_OnboardingSlideData>[
      _OnboardingSlideData(
        assetPath: 'assets/vectors/amico copy.svg',
        title: AppTexts.onboardingSlide1Title,
        subtitle: AppTexts.onboardingSlide1Subtitle,
        showWelcomeHeader: true,
      ),
      _OnboardingSlideData(
        assetPath: 'assets/vectors/cuate.svg',
        title: AppTexts.onboardingSlide2Title,
        subtitle: AppTexts.onboardingSlide2Subtitle,
      ),
      _OnboardingSlideData(
        assetPath: 'assets/vectors/amico.svg',
        title: AppTexts.onboardingSlide3Title,
        subtitle: AppTexts.onboardingSlide3Subtitle,
      ),
    ];

    return Scaffold(
      backgroundColor: colors.surfaceContainer,
      drawer: const HabitDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: slides.length,
                onPageChanged: (index) => currentPage.value = index,
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 68,
                          child: slide.showWelcomeHeader
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppTexts.welcomeTo,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300,
                                          color: colors.onSurface,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        AppTexts.appName,
                                        style: TextStyle(
                                          fontFamily: 'FugazOne',
                                          fontSize: 18,
                                          color: colors.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : null,
                        ),
                        Expanded(
                          child: Center(
                            child: SvgPicture.asset(
                              slide.assetPath,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide.title,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          slide.subtitle,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w400,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(slides.length, (index) {
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
                      color: isSelected
                          ? AppColors.primary
                          : colors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HabitPillButton(
                    label: AppTexts.createAccountUpper,
                    backgroundColor: AppColors.primary,
                    textColor: Colors.white,
                    onPressed: () =>
                        context.router.push(const CreateAccountRoute()),
                  ),
                  const SizedBox(height: 18),
                  _HabitPillButton(
                    label: AppTexts.logInUpper,
                    backgroundColor: colors.surfaceContainerLowest,
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
