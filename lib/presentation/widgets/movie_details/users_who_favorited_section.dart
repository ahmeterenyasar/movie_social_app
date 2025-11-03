import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_text_styles.dart';
import '../../../data/models/user_model.dart';
import '../../screens/profile_screen.dart';
import '../common/user_avatar.dart';

class UsersWhoFavoritedSection extends StatelessWidget {
  final List<UserModel> users;

  const UsersWhoFavoritedSection({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite, color: AppColors.error, size: 20),
              const SizedBox(width: AppConstants.paddingSmall),
              Text('Favoriye Ekleyenler', style: AppTextStyles.h3),
              const SizedBox(width: AppConstants.paddingSmall),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingSmall,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                ),
                child: Text(
                  users.length.toString(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.info,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),

          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return _buildUserItem(context, user);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserItem(BuildContext context, UserModel user) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProfileScreen(userId: user.id),
          ),
        );
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: AppConstants.paddingMedium),
        child: Column(
          children: [
            UserAvatar(
              name: user.fullName,
              size: AppConstants.avatarSizeMedium,
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              user.firstName,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            Text(
              '@${user.nickname}',
              style: AppTextStyles.caption.copyWith(color: AppColors.accent),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
