import 'package:flutter/material.dart';

import '../../../constants/app_constants.dart';
import '../../../data/models/movie_model.dart';
import '../common/movie_card.dart';

class ProfileFavoritesTab extends StatelessWidget {
  final List<MovieModel> movies;
  final List<int> favoriteMovieIds;
  final Function(MovieModel) onMovieTap;
  final Function(MovieModel) onFavoritePress;

  const ProfileFavoritesTab({
    super.key,
    required this.movies,
    required this.favoriteMovieIds,
    required this.onMovieTap,
    required this.onFavoritePress,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: AppConstants.paddingSmall,
        mainAxisSpacing: AppConstants.paddingSmall,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        final isFavorite = favoriteMovieIds.contains(movie.id);
        /* Showing the movies for "Favoriler" tab */
        return MovieCard(
          movie: movie,
          isFavorite: isFavorite,
          onTap: () => onMovieTap(movie),
          onFavoritePressed: () => onFavoritePress(movie),
        );
      },
    );
  }
}
