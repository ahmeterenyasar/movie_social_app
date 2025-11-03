import 'package:flutter/material.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/app_text_styles.dart';
import '../common/custom_button.dart';

class LoginFormActions extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onLogin;
  final VoidCallback onRegister;

  const LoginFormActions({
    super.key,
    required this.isLoading,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          text: 'Giriş Yap',
          onPressed: isLoading ? null : onLogin,
          isLoading: isLoading,
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        
        const LoginDivider(),
        
        const SizedBox(height: AppConstants.paddingMedium),
        
        CustomButton(
          text: 'Hesap Oluştur',
          onPressed: isLoading ? null : onRegister,
          type: ButtonType.outlined,
        ),
      ],
    );
  }
}

class LoginDivider extends StatelessWidget {
  const LoginDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
          ),
          child: Text(
            'veya',
            style: AppTextStyles.bodySmall,
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
