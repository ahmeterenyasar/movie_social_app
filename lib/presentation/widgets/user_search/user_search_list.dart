import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_constants.dart';
import '../../../data/models/user_model.dart';
import 'user_search_item.dart';

class UserSearchList extends StatelessWidget {
  final String currentUserId;
  final List<UserModel> users;
  final Function(String) onSendRequest;
  final Function(String) onUserTap;

  const UserSearchList({
    super.key,
    required this.currentUserId,
    required this.users,
    required this.onSendRequest,
    required this.onUserTap,
  });

  @override
  Widget build(BuildContext context) {
    final filteredUsers = users.where((user) => user.id != currentUserId).toList();

    if (filteredUsers.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppConstants.paddingLarge),
          child: Text(
            'Sonuç bulunamadı',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      itemCount: filteredUsers.length,
      separatorBuilder: (context, index) =>
          const Divider(color: AppColors.divider, height: 1),
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return UserSearchItem(
          user: user,
          currentUserId: currentUserId,
          onSendRequest: () => onSendRequest(user.id),
          onUserTap: () => onUserTap(user.id),
        );
      },
    );
  }
}
