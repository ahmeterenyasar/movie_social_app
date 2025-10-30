import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/movie_model.dart';
import '../data/models/user_model.dart';
import '../data/repositories/movie_repository.dart';
import '../data/repositories/user_repository.dart';

// States
abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object?> get props => [];
}

class MovieDetailInitial extends MovieDetailState {}
class MovieDetailLoading extends MovieDetailState {}

class MovieDetailLoaded extends MovieDetailState {
  final MovieModel movie;
  final List<MovieModel> similarMovies;
  final List<MovieModel> recommendedMovies;
  final List<UserModel> usersWhoFavorited;

  const MovieDetailLoaded({
    required this.movie,
    this.similarMovies = const [],
    this.recommendedMovies = const [],
    this.usersWhoFavorited = const [],
  });

  @override
  List<Object?> get props => [
        movie,
        similarMovies,
        recommendedMovies,
        usersWhoFavorited,
      ];

  MovieDetailLoaded copyWith({
    MovieModel? movie,
    List<MovieModel>? similarMovies,
    List<MovieModel>? recommendedMovies,
    List<UserModel>? usersWhoFavorited,
  }) {
    return MovieDetailLoaded(
      movie: movie ?? this.movie,
      similarMovies: similarMovies ?? this.similarMovies,
      recommendedMovies: recommendedMovies ?? this.recommendedMovies,
      usersWhoFavorited: usersWhoFavorited ?? this.usersWhoFavorited,
    );
  }
}

class MovieDetailError extends MovieDetailState {
  final String message;

  const MovieDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class MovieDetailCubit extends Cubit<MovieDetailState> {
  final MovieRepository _movieRepository;
  final UserRepository _userRepository;

  MovieDetailCubit({
    MovieRepository? movieRepository,
    UserRepository? userRepository,
  })  : _movieRepository = movieRepository ?? MovieRepository(),
        _userRepository = userRepository ?? UserRepository(),
        super(MovieDetailInitial());

  Future<void> loadMovieDetail(int movieId) async {
    emit(MovieDetailLoading());

    try {
      final movie = await _movieRepository.getMovieDetails(movieId);

      emit(MovieDetailLoaded(movie: movie));

      _loadAdditionalData(movieId);
    } catch (e) {
      emit(MovieDetailError(e.toString()));
    }
  }

  Future<void> _loadAdditionalData(int movieId) async {
    try {
      final currentState = state;
      if (currentState is! MovieDetailLoaded) return;

      final results = await Future.wait([
        _movieRepository.getSimilarMovies(movieId, page: 1),
        _movieRepository.getRecommendedMovies(movieId, page: 1),
        _userRepository.getUsersWhoFavoritedMovie(movieId),
      ]);

      emit(currentState.copyWith(
        similarMovies: results[0] as List<MovieModel>,
        recommendedMovies: results[1] as List<MovieModel>,
        usersWhoFavorited: results[2] as List<UserModel>,
      ));
    } catch (e) {
      print('Ek veriler yüklenemedi: $e');
    }
  }

  Future<void> loadSimilarMovies(int movieId) async {
    try {
      final currentState = state;
      if (currentState is! MovieDetailLoaded) return;

      final similarMovies = await _movieRepository.getSimilarMovies(movieId);
      emit(currentState.copyWith(similarMovies: similarMovies));
    } catch (e) {
      print('Benzer filmler yüklenemedi: $e');
    }
  }

  Future<void> loadRecommendedMovies(int movieId) async {
    try {
      final currentState = state;
      if (currentState is! MovieDetailLoaded) return;

      final recommendedMovies = await _movieRepository.getRecommendedMovies(movieId);
      emit(currentState.copyWith(recommendedMovies: recommendedMovies));
    } catch (e) {
      print('Önerilen filmler yüklenemedi: $e');
    }
  }

  Future<void> loadUsersWhoFavorited(int movieId) async {
    try {
      final currentState = state;
      if (currentState is! MovieDetailLoaded) return;

      final users = await _userRepository.getUsersWhoFavoritedMovie(movieId);
      emit(currentState.copyWith(usersWhoFavorited: users));
    } catch (e) {
      print('Favoriye ekleyen kullanıcılar yüklenemedi: $e');
    }
  }

  Future<void> refreshUsersWhoFavorited(int movieId) async {
    await loadUsersWhoFavorited(movieId);
  }

  void reset() {
    emit(MovieDetailInitial());
  }


  // Getters
  MovieModel? get currentMovie {
    final currentState = state;
    if (currentState is MovieDetailLoaded) {
      return currentState.movie;
    }
    return null;
  }

  List<UserModel> get usersWhoFavorited {
    final currentState = state;
    if (currentState is MovieDetailLoaded) {
      return currentState.usersWhoFavorited;
    }
    return [];
  }

  List<MovieModel> get similarMovies {
    final currentState = state;
    if (currentState is MovieDetailLoaded) {
      return currentState.similarMovies;
    }
    return [];
  }

  List<MovieModel> get recommendedMovies {
    final currentState = state;
    if (currentState is MovieDetailLoaded) {
      return currentState.recommendedMovies;
    }
    return [];
  }
}
