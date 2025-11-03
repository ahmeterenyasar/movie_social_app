import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_text_styles.dart';
import '../../../data/models/user_model.dart';

class ProfileStats extends StatelessWidget {
  final UserModel user;
  final int friendsCount;
  final VoidCallback? onFavoritesPressed;
  final VoidCallback? onFriendsPressed;

  const ProfileStats({
    super.key,
    required this.user,
    required this.friendsCount,
    this.onFavoritesPressed,
    this.onFriendsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingLarge,
        vertical: AppConstants.paddingMedium,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            icon: Icons.favorite,
            count: user.favoriteMovieIds.length,
            label: 'Favori',
            onTap: onFavoritesPressed,
          ),
          Container(width: 1, height: 40, color: AppColors.divider),
          _buildStatItem(
            icon: Icons.people,
            count: friendsCount,
            label: 'Arkadaş',
            onTap: onFriendsPressed,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required int count,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingLarge,
          vertical: AppConstants.paddingSmall,
        ),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: AppColors.accent,
                  size: AppConstants.iconSizeMedium,
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Text(
                  count.toString(),
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingXSmall),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
