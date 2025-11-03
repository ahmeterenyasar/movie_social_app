import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_text_styles.dart';
import '../../../data/models/user_model.dart';
import '../common/user_avatar.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;
  final bool isOwnProfile;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.isOwnProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppConstants.radiusLarge),
        ),
      ),
      child: Column(
        children: [
          UserAvatar(name: user.fullName, size: AppConstants.avatarSizeXLarge),
          const SizedBox(height: AppConstants.paddingMedium),

          Text(
            user.fullName,
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingXSmall),

          Text(
            '@${user.nickname}',
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.accent),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingXSmall),

          if (isOwnProfile)
            Text(
              user.email,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
