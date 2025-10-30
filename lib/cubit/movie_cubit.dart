import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/movie_model.dart';
import '../data/repositories/movie_repository.dart';

// States
abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object?> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<MovieModel> movies;
  final MovieCategory category;
  final int currentPage;
  final bool hasMorePages;

  const MovieLoaded({
    required this.movies,
    required this.category,
    this.currentPage = 1,
    this.hasMorePages = true,
  });

  @override
  List<Object?> get props => [movies, category, currentPage, hasMorePages];

  MovieLoaded copyWith({
    List<MovieModel>? movies,
    MovieCategory? category,
    int? currentPage,
    bool? hasMorePages,
  }) {
    return MovieLoaded(
      movies: movies ?? this.movies,
      category: category ?? this.category,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
    );
  }
}

class MovieError extends MovieState {
  final String message;

  const MovieError(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieSearchLoading extends MovieState {}

class MovieSearchLoaded extends MovieState {
  final List<MovieModel> movies;
  final String query;
  final int currentPage;
  final bool hasMorePages;

  const MovieSearchLoaded({
    required this.movies,
    required this.query,
    this.currentPage = 1,
    this.hasMorePages = true,
  });

  @override
  List<Object?> get props => [movies, query, currentPage, hasMorePages];
}

class MovieSearchError extends MovieState {
  final String message;

  const MovieSearchError(this.message);

  @override
  List<Object?> get props => [message];
}



enum MovieCategory {
  popular,
  trending,
  nowPlaying,
  upcoming,
  topRated,
}

// Cubit
class MovieCubit extends Cubit<MovieState> {
  final MovieRepository _movieRepository;

  MovieCubit({
    MovieRepository? movieRepository,
  })  : _movieRepository = movieRepository ?? MovieRepository(),
        super(MovieInitial());

  Future<void> loadMovies(MovieCategory category, {int page = 1}) async {
    if (page == 1) {
      emit(MovieLoading());
    }

    try {
      List<MovieModel> movies;

      switch (category) {
        case MovieCategory.popular:
          movies = await _movieRepository.getPopularMovies(page: page);
          break;
        case MovieCategory.trending:
          movies = await _movieRepository.getTrendingMovies(page: page);
          break;
        case MovieCategory.nowPlaying:
          movies = await _movieRepository.getNowPlayingMovies(page: page);
          break;
        case MovieCategory.upcoming:
          movies = await _movieRepository.getUpcomingMovies(page: page);
          break;
        case MovieCategory.topRated:
          movies = await _movieRepository.getTopRatedMovies(page: page);
          break;
      }

      final currentState = state;
      if (currentState is MovieLoaded && currentState.category == category && page > 1) {
        final updatedMovies = [...currentState.movies, ...movies];
        emit(MovieLoaded(
          movies: updatedMovies,
          category: category,
          currentPage: page,
          hasMorePages: movies.isNotEmpty,
        ));
      } else {
        emit(MovieLoaded(
          movies: movies,
          category: category,
          currentPage: page,
          hasMorePages: movies.isNotEmpty,
        ));
      }
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }

  Future<void> loadMoreMovies() async {
    final currentState = state;
    if (currentState is MovieLoaded && currentState.hasMorePages) {
      await loadMovies(
        currentState.category,
        page: currentState.currentPage + 1,
      );
    }
  }

  Future<void> searchMovies(String query, {int page = 1}) async {
    if (query.trim().isEmpty) {
      emit(MovieInitial());
      return;
    }

    if (page == 1) {
      emit(MovieSearchLoading());
    }

    try {
      final movies = await _movieRepository.searchMovies(query, page: page);

      final currentState = state;
      if (currentState is MovieSearchLoaded && currentState.query == query && page > 1) {
        final updatedMovies = [...currentState.movies, ...movies];
        emit(MovieSearchLoaded(
          movies: updatedMovies,
          query: query,
          currentPage: page,
          hasMorePages: movies.isNotEmpty,
        ));
      } else {
        emit(MovieSearchLoaded(
          movies: movies,
          query: query,
          currentPage: page,
          hasMorePages: movies.isNotEmpty,
        ));
      }
    } catch (e) {
      emit(MovieSearchError(e.toString()));
    }
  }

  Future<void> loadMoreSearchResults() async {
    final currentState = state;
    if (currentState is MovieSearchLoaded && currentState.hasMorePages) {
      await searchMovies(
        currentState.query,
        page: currentState.currentPage + 1,
      );
    }
  }

  void clearSearch() {
    emit(MovieInitial());
  }

  void reset() {
    emit(MovieInitial());
  }
}
