import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_text_styles.dart';
import '../../../cubit/movie_cubit.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final MovieCategory category;

  const CategoryChip({
    super.key,
    required this.label,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieCubit, MovieState>(
      builder: (context, state) {
        final isSelected = state is MovieLoaded && state.category == category;
        
        return Padding(
          padding: const EdgeInsets.only(right: AppConstants.paddingSmall),
          child: FilterChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                context.read<MovieCubit>().loadMovies(category);
              }
            },
            selectedColor: AppColors.accent,
            backgroundColor: AppColors.primaryLight,
            labelStyle: AppTextStyles.labelSmall.copyWith(
              color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        );
      },
    );
  }
}
