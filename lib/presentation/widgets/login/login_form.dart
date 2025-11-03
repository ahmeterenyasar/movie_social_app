import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import 'login_form_fields.dart';
import 'login_form_actions.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onSubmit;
  final VoidCallback onNavigateToRegister;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onSubmit,
    required this.onNavigateToRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const LoginHeader(),
          const SizedBox(height: AppConstants.paddingXLarge),
          LoginFormFields(
            emailController: emailController,
            passwordController: passwordController,
            isLoading: isLoading,
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          LoginFormActions(
            isLoading: isLoading,
            onLogin: onSubmit,
            onRegister: onNavigateToRegister,
          ),
        ],
      ),
    );
  }
}

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        LoginLogo(),
        SizedBox(height: AppConstants.paddingLarge),
        LoginTitle(),
      ],
    );
  }
}
