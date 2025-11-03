import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_constants.dart';
import '../../../cubit/movie_cubit.dart';
import '../../../data/models/movie_model.dart';
import '../common/error_widget.dart';
import '../common/loading_indicator.dart';
import 'movie_grid_item.dart';

class MovieGrid extends StatefulWidget {
  final Function(MovieModel) onMovieTap;
  final Function(MovieModel) onFavoriteTap;

  const MovieGrid({
    super.key,
    required this.onMovieTap,
    required this.onFavoriteTap,
  });

  @override
  State<MovieGrid> createState() => _MovieGridState();
}

class _MovieGridState extends State<MovieGrid> {
  final ScrollController _scrollController =
      ScrollController();

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent *
              0.9) {
        context.read<MovieCubit>().loadMoreMovies();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieCubit, MovieState>(
      builder: (context, state) {
        if (state is MovieLoading) {
          return const LoadingIndicator(
            message: 'Filmler yükleniyor...',
          );
        } else if (state is MovieLoaded) {
          return _buildMovieGrid(context, state);
        } else if (state is MovieError) {
          return CustomErrorWidget(
            message: state.message,
            onRetry: () {
              context.read<MovieCubit>().loadMovies(
                MovieCategory.popular,
              );
            },
          );
        } else {
          return const Center(
            child: Text('Filmler yüklenmedi'),
          );
        }
      },
    );
  }

  Widget _buildMovieGrid(
    BuildContext context,
    MovieLoaded state,
  ) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(
        AppConstants.paddingMedium,
      ),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
            crossAxisSpacing: AppConstants.paddingMedium,
            mainAxisSpacing: AppConstants.paddingMedium,
          ),
      itemCount:
          state.movies.length +
          (state.hasMorePages ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.movies.length) {
          return LoadingIndicator();
        }

        final movie = state.movies[index];
        return MovieGridItem(
          movie: movie,
          onTap: () => widget.onMovieTap(movie),
          onFavoriteTap: () => widget.onFavoriteTap(movie),
        );
      },
    );
  }
}
