import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../constants/app_colors.dart';
import '../../cubit/favorites_cubit.dart';
import '../../cubit/movie_detail_cubit.dart';
import '../../data/models/movie_model.dart';
import '../handlers/favorite_handler.dart';
import '../widgets/common/error_widget.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/movie_details/movie_backdrop.dart';
import '../widgets/movie_details/movie_info_section.dart';
import '../widgets/movie_details/movie_overview_section.dart';
import '../widgets/movie_details/similar_movies_section.dart';
import '../widgets/movie_details/users_who_favorited_section.dart';

class MovieDetailsScreen extends StatefulWidget {
  final MovieModel movie;

  const MovieDetailsScreen({
    super.key,
    required this.movie,
  });

  @override
  State<MovieDetailsScreen> createState() =>
      _MovieDetailsScreenState();
}

class _MovieDetailsScreenState
    extends State<MovieDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _loadMovieDetails();
  }

  void _loadMovieDetails() {
    context.read<MovieDetailCubit>().loadMovieDetail(
      widget.movie.id,
    );
  }

  Future<void> _handleFavoritePress() async {
    await FavoriteHandler.handleFavoritePress(
      context,
      widget.movie,
    );

    // Refresh users who favorited after favorite toggle
    if (mounted) {
      context
          .read<MovieDetailCubit>()
          .refreshUsersWhoFavorited(widget.movie.id);
    }
  }

  Future<void> _handleShare() async {
    final movie = widget.movie;

    try {
      final shareText =
          '''
        ${movie.title}
        Rating: ${movie.voteAverage.toStringAsFixed(1)}/10
        ${movie.overview}
        Poster: ${movie.fullPosterPath}
        ''';

      await SharePlus.instance.share(
        ShareParams(text: shareText, subject: movie.title),
      );
    } catch (e) {
      if (mounted) {
        _showErrorMessage('Paylaşım başarısız oldu');
      }
    }
  }

  void _handleMovieTap(MovieModel movie) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            MovieDetailsScreen(movie: movie),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /**
   *  BUILD
   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<MovieDetailCubit, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieDetailLoading) {
            return const LoadingIndicator(
              message: 'Film detayları yükleniyor...',
            );
          }

          if (state is MovieDetailError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: _loadMovieDetails,
            );
          }

          if (state is MovieDetailLoaded) {
            return _buildContent(state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(MovieDetailLoaded state) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(state.movie),
        _buildBody(state),
      ],
    );
  }


  SliverToBoxAdapter _buildBody(MovieDetailLoaded state) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MovieInfoSection(
            movie: state.movie,
            onFavoritePressed: _handleFavoritePress,
            onSharePressed: _handleShare,
          ),

          MovieOverviewSection(
            overview: state.movie.overview,
          ),

          if (state.usersWhoFavorited.isNotEmpty)
            UsersWhoFavoritedSection(
              users: state.usersWhoFavorited,
            ),

          if (state.similarMovies.isNotEmpty)
            SimilarMoviesSection(
              title: 'Benzer Filmler',
              movies: state.similarMovies,
              onMovieTap: _handleMovieTap,
            ),

          if (state.recommendedMovies.isNotEmpty)
            SimilarMoviesSection(
              title: 'Önerilen Filmler',
              movies: state.recommendedMovies,
              onMovieTap: _handleMovieTap,
            ),
        ],
      ),
    );
  }

  Widget _buildAppBar(MovieModel movie) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.overlayDark,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        /* Favorite button */
        BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, favState) {
            bool isFavorite = false;

            if (favState is FavoritesLoaded) {
              isFavorite = favState.isFavorite(movie.id);
            } else if (favState
                is FavoritesOperationLoading) {
              isFavorite = favState.isFavorite(movie.id);
            }

            return IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.overlayDark,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: isFavorite
                      ? Colors.red[400]
                      : Colors.white,
                ),
              ),
              onPressed: _handleFavoritePress,
            );
          },
        ),

        /* Share button */
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.overlayDark,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.share,
              color: Colors.white,
            ),
          ),
          onPressed: _handleShare,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: MovieBackdrop(
          backdropPath: movie.backdropPath,
          posterPath: movie.posterPath,
        ),
      ),
    );
  }
}
