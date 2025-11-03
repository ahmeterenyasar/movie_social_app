import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_text_styles.dart';

class MovieOverviewSection extends StatelessWidget {
  final String overview;

  const MovieOverviewSection({super.key, required this.overview});

  @override
  Widget build(BuildContext context) {
    if (overview.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hikaye', style: AppTextStyles.h3),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            overview,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
