import 'package:flutter/material.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/app_text_styles.dart';
import '../../../data/models/movie_model.dart';
import '../common/movie_card.dart';

class SimilarMoviesSection extends StatelessWidget {
  final String title;
  final List<MovieModel> movies;
  final Function(MovieModel) onMovieTap;

  const SimilarMoviesSection({
    super.key,
    required this.title,
    required this.movies,
    required this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingLarge,
            ),
            child: Text(title, style: AppTextStyles.h3),
          ),
          const SizedBox(height: AppConstants.paddingMedium),

          /* Movies list */
          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingLarge,
              ),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return Container(
                  width: 140,
                  margin: const EdgeInsets.only(
                    right: AppConstants.paddingMedium,
                  ),
                  child: MovieCard(
                    movie: movie,
                    onTap: () => onMovieTap(movie),
                    showFavoriteButton: false,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
