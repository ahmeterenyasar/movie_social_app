import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_text_styles.dart';

class UserAvatar extends StatelessWidget {
  final String name;
  final double size;
  final VoidCallback? onTap;

  const UserAvatar({
    super.key,
    required this.name,
    this.size = AppConstants.avatarSizeMedium,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.accentGradient,
          border: Border.all(
            color: AppColors.accent,
            width: 2,
          ),
        ),
        child: _buildInitials(),
    );
  }

  Widget _buildInitials() {
    final initials = _getInitials(name);
    final fontSize = size / 2.5;

    return Center(
      child: Text(
        initials,
        style: AppTextStyles.h4.copyWith(
          fontSize: fontSize,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
