import 'package:equatable/equatable.dart';

class MovieModel extends Equatable {
  const MovieModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.voteAverage = 0.0,
    this.voteCount = 0,
    this.popularity = 0.0,
    this.originalLanguage,
    this.genreIds = const [],
    this.adult = false,
  });

  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final double voteAverage;
  final int voteCount;
  final double popularity;
  final String? originalLanguage;
  final List<int> genreIds;
  final bool adult;

  String get fullPosterPath => posterPath.isNotEmpty 
      ? 'https://image.tmdb.org/t/p/w500$posterPath' 
      : '';

  String get fullBackdropPath => backdropPath != null && backdropPath!.isNotEmpty
      ? 'https://image.tmdb.org/t/p/original$backdropPath'
      : '';

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'],
      releaseDate: json['release_date'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      popularity: (json['popularity'] ?? 0).toDouble(),
      originalLanguage: json['original_language'],
      genreIds: json['genre_ids'] != null 
          ? List<int>.from(json['genre_ids']) 
          : [],
      adult: json['adult'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'popularity': popularity,
      'original_language': originalLanguage,
      'genre_ids': genreIds,
      'adult': adult,
    };
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
    };
  }

  MovieModel copyWith({
    int? id,
    String? title,
    String? overview,
    String? posterPath,
    String? backdropPath,
    String? releaseDate,
    double? voteAverage,
    int? voteCount,
    double? popularity,
    String? originalLanguage,
    List<int>? genreIds,
    bool? adult,
  }) {
    return MovieModel(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      releaseDate: releaseDate ?? this.releaseDate,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      popularity: popularity ?? this.popularity,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      genreIds: genreIds ?? this.genreIds,
      adult: adult ?? this.adult,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        overview,
        posterPath,
        backdropPath,
        releaseDate,
        voteAverage,
        voteCount,
        popularity,
        originalLanguage,
        genreIds,
        adult,
      ];
}
