import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../cubit/favorites_cubit.dart';
import '../../data/models/movie_model.dart';
import '../handlers/favorite_handler.dart';
import '../widgets/common/empty_state_widget.dart';
import '../widgets/common/error_widget.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/favorites/favorites_app_bar.dart';
import '../widgets/favorites/favorites_grid.dart';
import 'movie_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final String userId;

  const FavoritesScreen({super.key, required this.userId});

  @override
  State<FavoritesScreen> createState() =>
      _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final ScrollController _scrollController =
      ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeScreen();
    _setupScrollListener();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeScreen() {
    context.read<FavoritesCubit>().loadFavorites(
      widget.userId,
    );
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent *
              0.9) {
        _loadMoreFavorites();
      }
    });
  }

  void _loadMoreFavorites() {
    context.read<FavoritesCubit>().loadMoreFavorites(
      widget.userId,
    );
  }

  Future<void> _handleRefresh() async {
    await context.read<FavoritesCubit>().loadFavorites(
      widget.userId,
    );
  }

  void _handleMovieTap(MovieModel movie) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            MovieDetailsScreen(movie: movie),
      ),
    );
  }

  Future<void> _handleFavoritePress(
    MovieModel movie,
  ) async {
    await FavoriteHandler.handleFavoritePress(
      context,
      movie,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const FavoritesAppBar(),
      body: _buildFavoritesContent(),
    );
  }

  Widget _buildFavoritesContent() {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        if (state is FavoritesLoading) {
          return const LoadingIndicator(
            message: 'Favoriler yükleniyor...',
          );
        }

        if (state is FavoritesError) {
          return CustomErrorWidget(
            message: state.message,
            onRetry: () => context
                .read<FavoritesCubit>()
                .loadFavorites(widget.userId),
          );
        }

        if (state is FavoritesLoaded) {
          if (state.movies.isEmpty) {
            return _buildEmptyState();
          }
          /**/
          return RefreshIndicator(
            onRefresh: _handleRefresh,
            color: AppColors.accent,
            backgroundColor: AppColors.cardBackground,
            child: FavoritesGrid(
              movies: state.movies,
              favoriteMovieIds: state.favoriteMovieIds,
              scrollController: _scrollController,
              onMovieTap: _handleMovieTap,
              onFavoritePress: _handleFavoritePress,
              hasMorePages: state.hasMorePages,
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyState() {
    return EmptyStateWidget(
      icon: Icons.favorite_border,
      title: 'Henüz Favori Yok',
      message:
          'Beğendiğiniz filmleri favorilerinize ekleyin',
      actionText: 'Filmleri Keşfet',
      onActionPressed: () => Navigator.of(context).pop(),
    );
  }
}
