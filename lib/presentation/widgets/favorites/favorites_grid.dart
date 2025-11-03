import 'package:flutter/material.dart';
import 'package:movie_social_app/presentation/widgets/common/loading_indicator.dart';

import '../../../constants/app_constants.dart';
import '../../../data/models/movie_model.dart';
import '../common/movie_card.dart';

class FavoritesGrid extends StatelessWidget {
  final List<MovieModel> movies;
  final List<int> favoriteMovieIds;
  final ScrollController scrollController;
  final Function(MovieModel) onMovieTap;
  final Function(MovieModel) onFavoritePress;
  final bool hasMorePages;

  const FavoritesGrid({
    super.key,
    required this.movies,
    required this.favoriteMovieIds,
    required this.scrollController,
    required this.onMovieTap,
    required this.onFavoritePress,
    required this.hasMorePages,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(
        AppConstants.paddingMedium,
      ),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: AppConstants.paddingMedium,
            mainAxisSpacing: AppConstants.paddingMedium,
          ),
      itemCount: movies.length + (hasMorePages ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == movies.length && hasMorePages) {
          return LoadingIndicator();
        }

        final movie = movies[index];
        final isFavorite = favoriteMovieIds.contains(
          movie.id,
        );

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
