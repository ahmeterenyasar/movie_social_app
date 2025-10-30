import '../models/movie_model.dart';
import '../services/tmdb_api_service.dart';

class MovieRepository {
  final TmdbApiService _apiService;

  MovieRepository({TmdbApiService? apiService})
      : _apiService = apiService ?? TmdbApiService();

  Future<List<MovieModel>> getPopularMovies({int page = 1}) async {
    try {
      return await _apiService.getPopularMovies(page: page);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MovieModel>> getTrendingMovies({int page = 1}) async {
    try {
      return await _apiService.getTrendingMovies(page: page);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MovieModel>> getNowPlayingMovies({int page = 1}) async {
    try {
      return await _apiService.getNowPlayingMovies(page: page);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MovieModel>> getUpcomingMovies({int page = 1}) async {
    try {
      return await _apiService.getUpcomingMovies(page: page);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MovieModel>> getTopRatedMovies({int page = 1}) async {
    try {
      return await _apiService.getTopRatedMovies(page: page);
    } catch (e) {
      rethrow;
    }
  }

  // SEARCH
  Future<List<MovieModel>> searchMovies(String query, {int page = 1}) async {
    try {
      if (query.trim().isEmpty) return [];
      return await _apiService.searchMovies(query, page: page);
    } catch (e) {
      rethrow;
    }
  }

  // FILM DETAILS
  Future<MovieModel> getMovieDetails(int movieId) async {
    try {
      return await _apiService.getMovieDetails(movieId);
    } catch (e) {
      rethrow;
    }
  }

  // SIMILAR MOVIES
  Future<List<MovieModel>> getSimilarMovies(int movieId, {int page = 1}) async {
    try {
      return await _apiService.getSimilarMovies(movieId, page: page);
    } catch (e) {
      rethrow;
    }
  }

  /// RECOMMENDED
  Future<List<MovieModel>> getRecommendedMovies(int movieId, {int page = 1}) async {
    try {
      return await _apiService.getRecommendedMovies(movieId, page: page);
    } catch (e) {
      rethrow;
    }
  }

  // FAV FILM DETAILS
  /* 
  Implemented in order to display the user's favorite movies,
  details are retrieved for each movie from the movieId list.
  */
  Future<List<MovieModel>> getMoviesByIds(List<int> movieIds) async {
    try {
      if (movieIds.isEmpty) return [];

      final List<MovieModel> movies = [];
      
      for (final id in movieIds) {
        try {
          final movie = await _apiService.getMovieDetails(id);
          movies.add(movie);
        } catch (e) {
          print('Film ID $id alınamadı: $e');
        }
      }

      return movies;
    } catch (e) {
      rethrow;
    }
  }

  /*
  retrieves favorite movies by paging them
  */
  Future<List<MovieModel>> getFavoriteMoviesPaginated({
    required List<int> allFavoriteIds,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      if (allFavoriteIds.isEmpty) return [];

      final startIndex = (page - 1) * pageSize;
      final endIndex = startIndex + pageSize;

      if (startIndex >= allFavoriteIds.length) return [];

      final pageIds = allFavoriteIds.sublist(
        startIndex,
        endIndex > allFavoriteIds.length ? allFavoriteIds.length : endIndex,
      );

      return await getMoviesByIds(pageIds);
    } catch (e) {
      rethrow;
    }
  }
}
