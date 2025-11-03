import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../data/models/user_model.dart';

class ProfileAppBar extends StatelessWidget {
  final UserModel user;
  final bool isOwnProfile;
  final VoidCallback? onLogout;
  final VoidCallback? onSearchUsers;

  const ProfileAppBar({
    super.key,
    required this.user,
    required this.isOwnProfile,
    this.onLogout,
    this.onSearchUsers,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.background,
      title: Text(
        isOwnProfile ? 'Profilim' : user.nickname,
        style: AppTextStyles.h3,
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        if (isOwnProfile) ...[
          // Add friends button
          if (onSearchUsers != null)
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: onSearchUsers,
              tooltip: 'Kullanıcı Ara',
            ),
          // Logout button
          if (onLogout != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: onLogout,
              tooltip: 'Çıkış Yap',
            ),
        ],
      ],
    );
  }
}
