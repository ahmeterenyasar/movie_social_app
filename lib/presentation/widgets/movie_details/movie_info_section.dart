import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_text_styles.dart';
import '../../../cubit/favorites_cubit.dart';
import '../../../data/models/movie_model.dart';

class MovieInfoSection extends StatelessWidget {
  final MovieModel movie;
  final VoidCallback onFavoritePressed;
  final VoidCallback onSharePressed;

  const MovieInfoSection({
    super.key,
    required this.movie,
    required this.onFavoritePressed,
    required this.onSharePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* Title */
          Text(movie.title, style: AppTextStyles.h1),
          const SizedBox(height: AppConstants.paddingSmall),

          /* Release date and language */
          Row(
            children: [
              if (movie.releaseDate != null &&
                  movie.releaseDate!.isNotEmpty) ...[
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  _getReleaseYear(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
              ],
              if (movie.originalLanguage != null) ...[
                const Icon(
                  Icons.language,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  movie.originalLanguage!.toUpperCase(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),

          /* Rating and vote count */
          Row(
            children: [
              /* Rating */
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: AppConstants.paddingSmall,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusMedium,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppColors.ratingGold,
                      size: 24,
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    Text(
                      movie.voteAverage.toStringAsFixed(1),
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '/10',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),

              /* Vote counter */
              Text(
                '${movie.voteCount} oy',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingLarge),

          /* Action buttons ("favoriden çıkar" ve share) */
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        bool isFavorite = false;

        if (state is FavoritesLoaded) {
          isFavorite = state.isFavorite(movie.id);
        } else if (state is FavoritesOperationLoading) {
          isFavorite = state.isFavorite(movie.id);
        }

        return Row(
          children: [
            /* Favorite button */
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onFavoritePressed,
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                label: Text(
                  isFavorite ? 'Favorilerden Çıkar' : 'Favorilere Ekle',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFavorite
                      ? AppColors.error
                      : AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.paddingMedium,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusMedium,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppConstants.paddingMedium),

            /* Share button */
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: IconButton(
                onPressed: onSharePressed,
                icon: const Icon(Icons.share),
                color: AppColors.accent,
                iconSize: 28,
              ),
            ),
          ],
        );
      },
    );
  }

  String _getReleaseYear() {
    if (movie.releaseDate == null || movie.releaseDate!.isEmpty) {
      return 'N/A';
    }
    try {
      return movie.releaseDate!.split('-').first;
    } catch (e) {
      return 'N/A';
    }
  }
}
