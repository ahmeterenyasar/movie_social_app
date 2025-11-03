import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_text_styles.dart';
import '../../../data/models/user_model.dart';
import '../../screens/profile_screen.dart';
import '../common/user_avatar.dart';

class ProfileFriendsTab extends StatelessWidget {
  final List<UserModel> friends;

  const ProfileFriendsTab({super.key, required this.friends});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      itemCount: friends.length,
      separatorBuilder: (context, index) =>
          const Divider(color: AppColors.divider, height: 1),
      itemBuilder: (context, index) {
        final friend = friends[index];
        return _buildFriendItem(context, friend);
      },
    );
  }

  Widget _buildFriendItem(BuildContext context, UserModel friend) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingSmall,
        vertical: AppConstants.paddingXSmall,
      ),
      leading: UserAvatar(
        name: friend.fullName,
        size: AppConstants.avatarSizeMedium,
      ),
      title: Text(
        friend.fullName,
        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '@${friend.nickname}',
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          /* Favorites counter */
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingSmall,
              vertical: AppConstants.paddingXSmall,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite, size: 14, color: AppColors.error),
                const SizedBox(width: 4),
                Text(
                  friend.favoriteMovieIds.length.toString(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppConstants.paddingSmall),
          const Icon(Icons.chevron_right, color: AppColors.textTertiary),
        ],
      ),
      onTap: () {
        /* 
        Navigate to friend profile 
        BAK: hata: navigation'dan sonra, önceki sayfa navigated page'e eşitleniyor.
        */
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProfileScreen(userId: friend.id),
          ),
        );
      },
    );
  }
}
