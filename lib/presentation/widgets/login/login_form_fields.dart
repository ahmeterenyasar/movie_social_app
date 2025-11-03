import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_text_styles.dart';
import '../common/custom_text_field.dart';

class LoginFormFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;

  const LoginFormFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        /* Email */
        CustomTextField(
          label: 'E-posta',
          hint: 'ornek@email.com',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
          enabled: !isLoading,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'E-posta gerekli';
            }
            if (!value.contains('@')) {
              return 'Geçerli bir e-posta girin';
            }
            return null;
          },
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        
        /* Password */
        CustomTextField(
          label: 'Şifre',
          hint: 'Şifrenizi girin',
          controller: passwordController,
          obscureText: true,
          prefixIcon: Icons.lock_outlined,
          enabled: !isLoading,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Şifre gerekli';
            }
            if (value.length < 6) {
              return 'Şifre en az 6 karakter olmalı';
            }
            return null;
          },
        ),
      ],
    );
  }
}

/* Login logo widget */
class LoginLogo extends StatelessWidget {
  const LoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      ),
      child: const Icon(
        Icons.movie_outlined,
        size: 56,
        color: AppColors.textPrimary,
      ),
    );
  }
}

/* Login title widget */
class LoginTitle extends StatelessWidget {
  const LoginTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Hoş Geldiniz',
          style: AppTextStyles.h2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        Text(
          'Hesabınıza giriş yapın',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
