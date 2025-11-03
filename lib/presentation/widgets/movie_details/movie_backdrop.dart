import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_constants.dart';

class MovieBackdrop extends StatelessWidget {
  final String? backdropPath;
  final String posterPath;

  const MovieBackdrop({super.key, this.backdropPath, required this.posterPath});

  @override
  Widget build(BuildContext context) {
    /* Uses backdrop if it is available otherwise uses poster image*/
    final imagePath = (backdropPath != null && backdropPath!.isNotEmpty)
        ? '${AppConstants.tmdbImageBaseUrl}${AppConstants.backdropSize}$backdropPath'
        : '${AppConstants.tmdbImageBaseUrl}${AppConstants.posterSize}$posterPath';

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder();
          },
        ),

        // Gradient geçiş
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                AppColors.background.withValues(alpha: 0.7),
                AppColors.background,
              ],
              stops: const [0.0, 0.7, 1.0],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.surface,
      child: const Center(
        child: Icon(Icons.movie, size: 80, color: AppColors.textTertiary),
      ),
    );
  }
}
