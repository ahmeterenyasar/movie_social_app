import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/auth_cubit.dart';
import '../../../cubit/favorites_cubit.dart';
import '../../../data/models/movie_model.dart';
import '../common/movie_card.dart';

class MovieGridItem extends StatelessWidget {
  final MovieModel movie;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const MovieGridItem({
    super.key,
    required this.movie,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState is! Authenticated) {
          return MovieCard(
            movie: movie,
            onTap: onTap,
            onFavoritePressed: onFavoriteTap,
            isFavorite: false,
          );
        }

        return BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, favoritesState) {
            final isFavorite = context.read<FavoritesCubit>().isFavorite(movie.id);
            
            return MovieCard(
              movie: movie,
              onTap: onTap,
              onFavoritePressed: onFavoriteTap,
              isFavorite: isFavorite,
            );
          },
        );
      },
    );
  }
}
