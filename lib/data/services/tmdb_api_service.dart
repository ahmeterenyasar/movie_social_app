import 'package:dio/dio.dart';
import '../models/movie_model.dart';
import 'api_config.dart';

class TmdbApiService {
  final Dio _dio;

  TmdbApiService({Dio? dio}) 
      : _dio = dio ?? Dio(BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ));

  Future<List<MovieModel>> getPopularMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/movie/popular',
        queryParameters: {
          'api_key': ApiConfig.apiKey,
          'language': 'tr-TR',
          'page': page,
        },
      );

      final results = response.data['results'] as List;
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Popüler filmler alınamadı: $e');
    }
  }

  Future<List<MovieModel>> getTrendingMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/trending/movie/day',
        queryParameters: {
          'api_key': ApiConfig.apiKey,
          'language': 'tr-TR',
          'page': page,
        },
      );

      final results = response.data['results'] as List;
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Trend filmler alınamadı: $e');
    }
  }

  Future<List<MovieModel>> getNowPlayingMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/movie/now_playing',
        queryParameters: {
          'api_key': ApiConfig.apiKey,
          'language': 'tr-TR',
          'page': page,
        },
      );

      final results = response.data['results'] as List;
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Vizyondaki filmler alınamadı: $e');
    }
  }

  Future<List<MovieModel>> getUpcomingMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/movie/upcoming',
        queryParameters: {
          'api_key': ApiConfig.apiKey,
          'language': 'tr-TR',
          'page': page,
        },
      );

      final results = response.data['results'] as List;
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Yakında gelecek filmler alınamadı: $e');
    }
  }

  Future<List<MovieModel>> getTopRatedMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/movie/top_rated',
        queryParameters: {
          'api_key': ApiConfig.apiKey,
          'language': 'tr-TR',
          'page': page,
        },
      );

      final results = response.data['results'] as List;
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('En çok oylanan filmler alınamadı: $e');
    }
  }

  Future<List<MovieModel>> searchMovies(String query, {int page = 1}) async {
    try {
      if (query.isEmpty) return [];

      final response = await _dio.get(
        '/search/movie',
        queryParameters: {
          'api_key': ApiConfig.apiKey,
          'language': 'tr-TR',
          'query': query,
          'page': page,
        },
      );

      final results = response.data['results'] as List;
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Film araması yapılamadı: $e');
    }
  }

  Future<MovieModel> getMovieDetails(int movieId) async {
    try {
      final response = await _dio.get(
        '/movie/$movieId',
        queryParameters: {
          'api_key': ApiConfig.apiKey,
          'language': 'tr-TR',
        },
      );

      return MovieModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Film detayları alınamadı: $e');
    }
  }

  Future<List<MovieModel>> getSimilarMovies(int movieId, {int page = 1}) async {
    try {
      final response = await _dio.get(
        '/movie/$movieId/similar',
        queryParameters: {
          'api_key': ApiConfig.apiKey,
          'language': 'tr-TR',
          'page': page,
        },
      );

      final results = response.data['results'] as List;
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Benzer filmler alınamadı: $e');
    }
  }

  Future<List<MovieModel>> getRecommendedMovies(int movieId, {int page = 1}) async {
    try {
      final response = await _dio.get(
        '/movie/$movieId/recommendations',
        queryParameters: {
          'api_key': ApiConfig.apiKey,
          'language': 'tr-TR',
          'page': page,
        },
      );

      final results = response.data['results'] as List;
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Önerilen filmler alınamadı: $e');
    }
  }
}
