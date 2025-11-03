import 'package:flutter/material.dart';

import '../../../constants/app_constants.dart';
import 'register_form_fields.dart';

/// Registration form widget
class RegisterForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController nicknameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isLoading;
  final VoidCallback onSubmit;
  final VoidCallback onBackToLogin;

  const RegisterForm({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.nicknameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isLoading,
    required this.onSubmit,
    required this.onBackToLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RegisterFormFields(
            firstNameController: firstNameController,
            lastNameController: lastNameController,
            nicknameController: nicknameController,
            emailController: emailController,
            passwordController: passwordController,
            confirmPasswordController: confirmPasswordController,
            isLoading: isLoading,
          ),
          const SizedBox(height: AppConstants.paddingXLarge),
          RegisterFormActions(
            isLoading: isLoading,
            onSubmit: onSubmit,
            onBackToLogin: onBackToLogin,
          ),
        ],
      ),
    );
  }
}
