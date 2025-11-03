import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_text_styles.dart';
import '../../../cubit/user_cubit.dart';
import '../../../data/models/user_model.dart';
import '../common/user_avatar.dart';

class UserSearchItem extends StatelessWidget {
  final UserModel user;
  final String currentUserId;
  final VoidCallback onSendRequest;
  final VoidCallback onUserTap;

  const UserSearchItem({
    super.key,
    required this.user,
    required this.currentUserId,
    required this.onSendRequest,
    required this.onUserTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingSmall,
        vertical: AppConstants.paddingXSmall,
      ),
      leading: UserAvatar(
        name: user.fullName,
        size: AppConstants.avatarSizeMedium,
      ),
      title: Text(
        user.fullName,
        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '@${user.nickname}',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.accent),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.favorite, size: 14, color: AppColors.error),
              const SizedBox(width: 4),
              Text(
                '${user.favoriteMovieIds.length} favori',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: _buildActionButton(context),
      onTap: onUserTap,
    );
  }

  /* action buttons -> friendship status */
  Widget _buildActionButton(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserSearchLoaded) {
          /* Already friends */
          if (state.isFriend(user.id)) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.2),
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusSmall),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 16,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Arkadaş',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }

          /* Request already sent */
          if (state.hasSentRequestTo(user.id)) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.2),
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusSmall),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.schedule,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'İstek Gönderildi',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }

          /* Request send to another user */
          if (state.hasPendingRequestFrom(user.id)) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.2),
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusSmall),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.notifications_active,
                    size: 16,
                    color: AppColors.accent,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'İstek Var',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }
        }

        /* Not friend, can send request */
        return IconButton(
          icon: const Icon(Icons.person_add, color: AppColors.accent),
          onPressed: onSendRequest,
          tooltip: 'Arkadaş Ekle',
        );
      },
    );
  }
}
