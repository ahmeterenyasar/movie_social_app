import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/movie_model.dart';
import '../data/repositories/movie_repository.dart';
import '../data/repositories/user_repository.dart';

// States
abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<MovieModel> movies;
  final List<int> favoriteMovieIds;
  final int currentPage;
  final bool hasMorePages;

  const FavoritesLoaded({
    required this.movies,
    required this.favoriteMovieIds,
    this.currentPage = 1,
    this.hasMorePages = true,
  });

  @override
  List<Object?> get props => [movies, favoriteMovieIds, currentPage, hasMorePages];

  bool isFavorite(int movieId) => favoriteMovieIds.contains(movieId);

  FavoritesLoaded copyWith({
    List<MovieModel>? movies,
    List<int>? favoriteMovieIds,
    int? currentPage,
    bool? hasMorePages,
  }) {
    return FavoritesLoaded(
      movies: movies ?? this.movies,
      favoriteMovieIds: favoriteMovieIds ?? this.favoriteMovieIds,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
    );
  }
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}

class FavoritesOperationLoading extends FavoritesState {
  final List<int> favoriteMovieIds;

  const FavoritesOperationLoading(this.favoriteMovieIds);

  @override
  List<Object?> get props => [favoriteMovieIds];

  bool isFavorite(int movieId) => favoriteMovieIds.contains(movieId);
}

// Cubit
class FavoritesCubit extends Cubit<FavoritesState> {
  final MovieRepository _movieRepository;
  final UserRepository _userRepository;

  FavoritesCubit({
    MovieRepository? movieRepository,
    UserRepository? userRepository,
  })  : _movieRepository = movieRepository ?? MovieRepository(),
        _userRepository = userRepository ?? UserRepository(),
        super(FavoritesInitial());

  Future<void> loadFavorites(String userId, {int page = 1}) async {
    if (page == 1) {
      emit(FavoritesLoading());
    }

    try {
      final allFavoriteIds = await _userRepository.getUserFavoriteMovies(userId);

      if (allFavoriteIds.isEmpty) {
        emit(const FavoritesLoaded(
          movies: [],
          favoriteMovieIds: [],
          currentPage: 1,
          hasMorePages: false,
        ));
        return;
      }

      final movies = await _movieRepository.getFavoriteMoviesPaginated(
        allFavoriteIds: allFavoriteIds,
        page: page,
        pageSize: 20,
      );

      final currentState = state;
      if (currentState is FavoritesLoaded && page > 1) {
        final updatedMovies = [...currentState.movies, ...movies];
        emit(FavoritesLoaded(
          movies: updatedMovies,
          favoriteMovieIds: allFavoriteIds,
          currentPage: page,
          hasMorePages: movies.length == 20,
        ));
      } else {
        emit(FavoritesLoaded(
          movies: movies,
          favoriteMovieIds: allFavoriteIds,
          currentPage: page,
          hasMorePages: movies.length == 20,
        ));
      }
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> loadMoreFavorites(String userId) async {
    final currentState = state;
    if (currentState is FavoritesLoaded && currentState.hasMorePages) {
      await loadFavorites(userId, page: currentState.currentPage + 1);
    }
  }

  Future<void> addToFavorites(String userId, int movieId) async {
    try {
      final currentState = state;
      List<int> currentFavorites = [];

      if (currentState is FavoritesLoaded) {
        currentFavorites = List.from(currentState.favoriteMovieIds);
      }

      if (currentFavorites.contains(movieId)) {
        return;
      }

      emit(FavoritesOperationLoading([...currentFavorites, movieId]));

      await _userRepository.addMovieToFavorites(userId, movieId);

      await loadFavorites(userId);
    } catch (e) {
      emit(FavoritesError(e.toString()));
      final currentState = state;
      if (currentState is FavoritesError) {
        rethrow;
      }
    }
  }

  Future<void> removeFromFavorites(String userId, int movieId) async {
    try {
      final currentState = state;
      List<int> currentFavorites = [];

      if (currentState is FavoritesLoaded) {
        currentFavorites = List.from(currentState.favoriteMovieIds);
      }

      if (!currentFavorites.contains(movieId)) {
        return;
      }

      currentFavorites.remove(movieId);
      emit(FavoritesOperationLoading(currentFavorites));

      await _userRepository.removeMovieFromFavorites(userId, movieId);

      await loadFavorites(userId);
    } catch (e) {
      emit(FavoritesError(e.toString()));
      rethrow;
    }
  }

  Future<void> toggleFavorite(String userId, int movieId) async {
    final currentState = state;
    
    if (currentState is FavoritesLoaded) {
      if (currentState.isFavorite(movieId)) {
        await removeFromFavorites(userId, movieId);
      } else {
        await addToFavorites(userId, movieId);
      }
    } else if (currentState is FavoritesOperationLoading) {
      if (currentState.isFavorite(movieId)) {
        await removeFromFavorites(userId, movieId);
      } else {
        await addToFavorites(userId, movieId);
      }
    } else {
      await addToFavorites(userId, movieId);
    }
  }

  bool isFavorite(int movieId) {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      return currentState.isFavorite(movieId);
    } else if (currentState is FavoritesOperationLoading) {
      return currentState.isFavorite(movieId);
    }
    return false;
  }

  List<int> get favoriteMovieIds {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      return currentState.favoriteMovieIds;
    } else if (currentState is FavoritesOperationLoading) {
      return currentState.favoriteMovieIds;
    }
    return [];
  }

  void reset() {
    emit(FavoritesInitial());
  }
}
