import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_text_styles.dart';
import '../common/custom_button.dart';
import '../common/custom_text_field.dart';

class RegisterFormFields extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController nicknameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isLoading;

  const RegisterFormFields({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.nicknameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const RegisterInfoText(),
        const SizedBox(height: AppConstants.paddingLarge),
        
        CustomTextField(
          label: 'Ad',
          hint: 'Adınız',
          controller: firstNameController,
          prefixIcon: Icons.person_outline,
          enabled: !isLoading,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ad gerekli';
            }
            return null;
          },
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        
        CustomTextField(
          label: 'Soyad',
          hint: 'Soyadınız',
          controller: lastNameController,
          prefixIcon: Icons.person_outline,
          enabled: !isLoading,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Soyad gerekli';
            }
            return null;
          },
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        
        CustomTextField(
          label: 'Kullanıcı Adı',
          hint: 'Benzersiz kullanıcı adı',
          controller: nicknameController,
          prefixIcon: Icons.alternate_email,
          enabled: !isLoading,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Kullanıcı adı gerekli';
            }
            if (value.length < 3) {
              return 'Kullanıcı adı en az 3 karakter olmalı';
            }
            if (value.contains(' ')) {
              return 'Kullanıcı adı boşluk içeremez';
            }
            return null;
          },
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        
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
        
        CustomTextField(
          label: 'Şifre',
          hint: 'En az 6 karakter',
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
        const SizedBox(height: AppConstants.paddingMedium),
        
        CustomTextField(
          label: 'Şifre Tekrar',
          hint: 'Şifrenizi tekrar girin',
          controller: confirmPasswordController,
          obscureText: true,
          prefixIcon: Icons.lock_outlined,
          enabled: !isLoading,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Şifre tekrarı gerekli';
            }
            if (value != passwordController.text) {
              return 'Şifreler eşleşmiyor';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class RegisterInfoText extends StatelessWidget {
  const RegisterInfoText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Bilgilerinizi girerek hesap oluşturun',
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondary,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class RegisterFormActions extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSubmit;
  final VoidCallback onBackToLogin;

  const RegisterFormActions({
    super.key,
    required this.isLoading,
    required this.onSubmit,
    required this.onBackToLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /* Register Button */
        CustomButton(
          height: 50,
          text: 'Kayıt Ol',
          onPressed: isLoading ? null : onSubmit,
          isLoading: isLoading,
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        
        /* Back to Login */
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Zaten hesabınız var mı? ',
              style: AppTextStyles.bodyMedium,
            ),
            TextButton(
              onPressed: isLoading ? null : onBackToLogin,
              child: const Text('Giriş Yap'),
            ),
          ],
        ),
      ],
    );
  }
}
