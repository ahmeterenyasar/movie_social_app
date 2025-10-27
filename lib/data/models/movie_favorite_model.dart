import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MovieFavoriteModel extends Equatable {
  const MovieFavoriteModel({
    required this.movieId,
    this.userIds = const [],
    this.count = 0,
    this.lastUpdated,
  });

  final int movieId;
  final List<String> userIds;
  final int count;
  final DateTime? lastUpdated;

  factory MovieFavoriteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MovieFavoriteModel(
      movieId: int.parse(doc.id),
      userIds: List<String>.from(data['userIds'] ?? []),
      count: data['count'] ?? 0,
      lastUpdated: data['lastUpdated'] != null
          ? (data['lastUpdated'] as Timestamp).toDate()
          : null,
    );
  }

  factory MovieFavoriteModel.fromMap(Map<String, dynamic> map, int movieId) {
    return MovieFavoriteModel(
      movieId: movieId,
      userIds: List<String>.from(map['userIds'] ?? []),
      count: map['count'] ?? 0,
      lastUpdated: map['lastUpdated'] != null
          ? (map['lastUpdated'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userIds': userIds,
      'count': count,
      'lastUpdated': lastUpdated != null
          ? Timestamp.fromDate(lastUpdated!)
          : FieldValue.serverTimestamp(),
    };
  }

  MovieFavoriteModel addUser(String userId) {
    if (userIds.contains(userId)) return this;
    
    return copyWith(
      userIds: [...userIds, userId],
      count: count + 1,
      lastUpdated: DateTime.now(),
    );
  }

  MovieFavoriteModel removeUser(String userId) {
    if (!userIds.contains(userId)) return this;
    
    final newUserIds = List<String>.from(userIds)..remove(userId);
    return copyWith(
      userIds: newUserIds,
      count: count - 1,
      lastUpdated: DateTime.now(),
    );
  }

  MovieFavoriteModel copyWith({
    int? movieId,
    List<String>? userIds,
    int? count,
    DateTime? lastUpdated,
  }) {
    return MovieFavoriteModel(
      movieId: movieId ?? this.movieId,
      userIds: userIds ?? this.userIds,
      count: count ?? this.count,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [movieId, userIds, count, lastUpdated];
}
