import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notes/app/router/app_router.dart';
import 'package:notes/app/theme/app_theme.dart';
import 'package:notes/core/l10n/app_texts.dart';
import 'package:notes/features/auth/presentation/controllers/auth_controller.dart';

@RoutePage()
class CreateAccountScreen extends HookConsumerWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayNameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final obscurePassword = useState(true);
    final colors = Theme.of(context).colorScheme;

    final authActionState = ref.watch(authControllerProvider);

    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: colors.error,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: colors.surfaceContainer,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.router.maybePop(),
        ),
        title: Text(
          AppTexts.createAccount,
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppTexts.letsGetToKnowYou,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppTexts.enterDetailsToContinue,
                      style: TextStyle(
                        fontSize: 15,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 28),
                    TextField(
                      controller: displayNameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: AppTexts.displayName,
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: AppColors.primary,
                        ),
                        filled: true,
                        fillColor: colors.surfaceContainerLowest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: AppTexts.emailAddress,
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: AppColors.primary,
                        ),
                        filled: true,
                        fillColor: colors.surfaceContainerLowest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      obscureText: obscurePassword.value,
                      decoration: InputDecoration(
                        hintText: AppTexts.password,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.primary,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: colors.onSurfaceVariant,
                          ),
                          onPressed: () =>
                              obscurePassword.value = !obscurePassword.value,
                        ),
                        filled: true,
                        fillColor: colors.surfaceContainerLowest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: obscurePassword.value,
                      decoration: InputDecoration(
                        hintText: AppTexts.confirmPassword,
                        prefixIcon: const SizedBox(width: 48),
                        filled: true,
                        fillColor: colors.surfaceContainerLowest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppTexts.alreadyHaveAccount,
                          style: TextStyle(
                            fontSize: 14.5,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () =>
                              context.router.replace(const LoginRoute()),
                          child: Text(
                            AppTexts.loginHere,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const SizedBox(height: 32),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 13.5,
                          color: colors.onSurfaceVariant,
                          height: 1.4,
                        ),
                        children: [
                          TextSpan(text: AppTexts.termsAgreementPrefix),
                          TextSpan(
                            text: AppTexts.termsOfUse,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: colors.onSurface,
                            ),
                          ),
                          TextSpan(text: AppTexts.andWord),
                          TextSpan(
                            text: AppTexts.privacyPolicy,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: colors.onSurface,
                            ),
                          ),
                          TextSpan(text: AppTexts.termsAgreementSuffix),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: authActionState.isLoading
                            ? null
                            : () async {
                                final success = await ref
                                    .read(authControllerProvider.notifier)
                                    .signUp(
                                      displayName: displayNameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      confirmPassword:
                                          confirmPasswordController.text,
                                    );
                                if (success && context.mounted) {
                                  await context.router.replaceAll([
                                    MainShellRoute(),
                                  ]);
                                }
                              },
                        child: authActionState.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                AppTexts.createAccountUpper,
                                style: const TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
