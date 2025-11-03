import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/friendship_model.dart';
import '../models/movie_favorite_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _friendshipsCollection => _firestore.collection('friendships');
  CollectionReference get _movieFavoritesCollection => _firestore.collection('movieFavorites');

  Future<void> createUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.id).set(user.toMap());
    } catch (e) {
      throw Exception('Kullanıcı oluşturulamadı: $e');
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Kullanıcı bilgileri alınamadı: $e');
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.id).update(user.toMap());
    } catch (e) {
      throw Exception('Kullanıcı bilgileri güncellenemedi: $e');
    }
  }

  Future<List<UserModel>> searchUsersByNickname(String nickname) async {
    try {
      final querySnapshot = await _usersCollection
          .where('nickname', isGreaterThanOrEqualTo: nickname)
          .where('nickname', isLessThanOrEqualTo: '$nickname\uf8ff')
          .limit(20)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Kullanıcı araması yapılamadı: $e');
    }
  }

  Future<bool> isNicknameAvailable(String nickname) async {
    try {
      final querySnapshot = await _usersCollection
          .where('nickname', isEqualTo: nickname)
          .limit(1)
          .get();

      return querySnapshot.docs.isEmpty;
    } catch (e) {
      throw Exception('Nickname kontrolü yapılamadı: $e');
    }
  }

  Future<void> addMovieToFavorites(String userId, int movieId) async {
    try {
      await _usersCollection.doc(userId).update({
        'favoriteMovieIds': FieldValue.arrayUnion([movieId]),
      });
    } catch (e) {
      throw Exception('Film favorilere eklenemedi: $e');
    }
  }

  Future<void> removeMovieFromFavorites(String userId, int movieId) async {
    try {
      await _usersCollection.doc(userId).update({
        'favoriteMovieIds': FieldValue.arrayRemove([movieId]),
      });
    } catch (e) {
      throw Exception('Film favorilerden çıkarılamadı: $e');
    }
  }

  // ARKADAŞLIK
  Future<void> sendFriendRequest(String senderId, String receiverId) async {
    try {
      // Check if already friends
      final sender = await getUser(senderId);
      if (sender != null &&
          sender.friendIds.contains(receiverId)) {
        throw Exception('Bu kullanıcı zaten arkadaşınız');
      }

      // Check if request already exists (either direction)
      final existingRequest = await _friendshipsCollection
          .where('senderId', isEqualTo: senderId)
          .where('receiverId', isEqualTo: receiverId)
          .where('status', isEqualTo: 'pending')
          .get();

      if (existingRequest.docs.isNotEmpty) {
        throw Exception(
          'Bu kullanıcıya zaten arkadaşlık isteği gönderilmiş',
        );
      }

      // Check reverse direction (if they sent to us)
      final reverseRequest = await _friendshipsCollection
          .where('senderId', isEqualTo: receiverId)
          .where('receiverId', isEqualTo: senderId)
          .where('status', isEqualTo: 'pending')
          .get();

      if (reverseRequest.docs.isNotEmpty) {
        throw Exception(
          'Bu kullanıcı size zaten arkadaşlık isteği göndermiş',
        );
      }

      final friendship = FriendshipModel(
        id: '',
        senderId: senderId,
        receiverId: receiverId,
        status: FriendshipStatus.pending,
        createdAt: DateTime.now(),
      );

      await _friendshipsCollection.add(friendship.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> acceptFriendRequest(String friendshipId, String userId, String friendId) async {
    try {
      await _friendshipsCollection.doc(friendshipId).update({
        'status': 'accepted',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await _usersCollection.doc(userId).update({
        'friendIds': FieldValue.arrayUnion([friendId]),
      });
      await _usersCollection.doc(friendId).update({
        'friendIds': FieldValue.arrayUnion([userId]),
      });

    } catch (e) {
      throw Exception('Arkadaşlık isteği kabul edilemedi: $e');
    }
  }

  Future<void> rejectFriendRequest(String friendshipId) async {
    try {
      await _friendshipsCollection.doc(friendshipId).update({
        'status': 'rejected',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Arkadaşlık isteği reddedilemedi: $e');
    }
  }

  Future<List<FriendshipModel>> getPendingFriendRequests(String userId) async {
    try {
      final querySnapshot = await _friendshipsCollection
          .where('receiverId', isEqualTo: userId)
          .where('status', isEqualTo: 'pending')
          .get();

      return querySnapshot.docs
          .map((doc) => FriendshipModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Arkadaşlık istekleri alınamadı: $e');
    }
  }

  Future<List<FriendshipModel>> getSentFriendRequests(
    String userId,
  ) async {
    try {
      final querySnapshot = await _friendshipsCollection
          .where('senderId', isEqualTo: userId)
          .where('status', isEqualTo: 'pending')
          .get();

      return querySnapshot.docs
          .map((doc) => FriendshipModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Gönderilen istekler alınamadı: $e');
    }
  }

  Future<List<UserModel>> getFriends(String userId) async {
    try {
      final user = await getUser(userId);
      if (user == null || user.friendIds.isEmpty) return [];

      final friendsSnapshot = await _usersCollection
          .where(FieldPath.documentId, whereIn: user.friendIds).get();

      return friendsSnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Arkadaşlar alınamadı: $e');
    }
  }

  Future<MovieFavoriteModel?> getMovieFavorites(int movieId) async {
    try {
      final doc = await _movieFavoritesCollection.doc(movieId.toString()).get();
      if (!doc.exists) return null;
      return MovieFavoriteModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Film favori bilgileri alınamadı: $e');
    }
  }

  Future<void> addUserToMovieFavorites(int movieId, String userId) async {
    try {
      final docRef = _movieFavoritesCollection.doc(movieId.toString());
      final doc = await docRef.get();

      if (doc.exists) {
        await docRef.update({
          'userIds': FieldValue.arrayUnion([userId]),
          'count': FieldValue.increment(1),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      } else {
        final movieFavorite = MovieFavoriteModel(
          movieId: movieId,
          userIds: [userId],
          count: 1,
          lastUpdated: DateTime.now(),
        );
        await docRef.set(movieFavorite.toMap());
      }
    } catch (e) {
      throw Exception('Film favori bilgisi güncellenemedi: $e');
    }
  }

  Future<void> removeUserFromMovieFavorites(int movieId, String userId) async {
    try {
      final docRef = _movieFavoritesCollection.doc(movieId.toString());
      await docRef.update({
        'userIds': FieldValue.arrayRemove([userId]),
        'count': FieldValue.increment(-1),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Film favori bilgisi güncellenemedi: $e');
    }
  }

  Future<List<UserModel>> getUsersWhoFavoritedMovie(int movieId) async {
    try {
      final movieFavorite = await getMovieFavorites(movieId);
      if (movieFavorite == null || movieFavorite.userIds.isEmpty) return [];

      final usersSnapshot = await _usersCollection
          .where(FieldPath.documentId, whereIn: movieFavorite.userIds)
          .get();

      return usersSnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Kullanıcı bilgileri alınamadı: $e');
    }
  }
}
