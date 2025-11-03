import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_text_styles.dart';
import '../../../data/models/friendship_model.dart';
import '../../../data/models/user_model.dart';
import '../common/empty_state_widget.dart';
import 'pending_request_item.dart';

class PendingRequestsSection extends StatelessWidget {
  final String currentUserId;
  final List<FriendshipModel> pendingRequests;
  final Map<String, UserModel> senderUsers;
  final Function(String, String) onAccept;
  final Function(String) onReject;
  final Function(String) onUserTap;

  const PendingRequestsSection({
    super.key,
    required this.currentUserId,
    required this.pendingRequests,
    required this.senderUsers,
    required this.onAccept,
    required this.onReject,
    required this.onUserTap,
  });

  @override
  Widget build(BuildContext context) {
    if (pendingRequests.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.notifications_none,
        title: 'Bekleyen İstek Yok',
        message: 'Arkadaşlık isteği bulunmamaktadır',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        /* Header */
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(color: AppColors.divider, width: 1),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.notifications_active, color: AppColors.accent),
              const SizedBox(width: AppConstants.paddingSmall),
              Text('Bekleyen İstekler', style: AppTextStyles.h4),
              const SizedBox(width: AppConstants.paddingSmall),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingSmall,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                ),
                child: Text(
                  pendingRequests.length.toString(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        /* Requests list */
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            itemCount: pendingRequests.length,
            separatorBuilder: (context, index) =>
                const Divider(color: AppColors.divider, height: 1),
            itemBuilder: (context, index) {
              final request = pendingRequests[index];
              final senderUser = senderUsers[request.senderId];

              // Skip if sender user not loaded
              if (senderUser == null) {
                return const SizedBox.shrink();
              }

              return PendingRequestItem(
                friendshipId: request.id,
                senderUser: senderUser,
                onAccept: onAccept,
                onReject: onReject,
                onUserTap: onUserTap,
              );
            },
          ),
        ),
      ],
    );
  }
}
