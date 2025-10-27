import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.nickname,
    required this.email,
    this.favoriteMovieIds = const [],
    this.friendIds = const [],
    this.createdAt,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String nickname;
  final String email;
  final List<int> favoriteMovieIds;
  final List<String> friendIds;
  final DateTime? createdAt;

  String get fullName => '$firstName $lastName';

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      nickname: data['nickname'] ?? '',
      email: data['email'] ?? '',
      favoriteMovieIds: List<int>.from(data['favoriteMovieIds'] ?? []),
      friendIds: List<String>.from(data['friendIds'] ?? []),
      createdAt: data['createdAt'] != null 
          ? (data['createdAt'] as Timestamp).toDate() 
          : null,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      nickname: map['nickname'] ?? '',
      email: map['email'] ?? '',
      favoriteMovieIds: List<int>.from(map['favoriteMovieIds'] ?? []),
      friendIds: List<String>.from(map['friendIds'] ?? []),
      createdAt: map['createdAt'] != null 
          ? (map['createdAt'] as Timestamp).toDate() 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'nickname': nickname,
      'email': email,
      'favoriteMovieIds': favoriteMovieIds,
      'friendIds': friendIds,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? nickname,
    String? email,
    List<int>? favoriteMovieIds,
    List<String>? friendIds,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      favoriteMovieIds: favoriteMovieIds ?? this.favoriteMovieIds,
      friendIds: friendIds ?? this.friendIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        nickname,
        email,
        favoriteMovieIds,
        friendIds,
        createdAt,
      ];
}
