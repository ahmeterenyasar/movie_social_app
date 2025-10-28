import '../models/user_model.dart';
import '../models/friendship_model.dart';
import '../services/firestore_service.dart';

class UserRepository {
  final FirestoreService _firestoreService;

  UserRepository({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  // USER
  Future<UserModel?> getUser(String userId) async {
    try {
      return await _firestoreService.getUser(userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _firestoreService.updateUser(user);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserModel>> searchUsers(String nickname) async {
    try {
      return await _firestoreService.searchUsersByNickname(nickname);
    } catch (e) {
      rethrow;
    }
  }

  // FAVORİ
  Future<void> addMovieToFavorites(String userId, int movieId) async {
    try {
      await _firestoreService.addMovieToFavorites(userId, movieId);
      await _firestoreService.addUserToMovieFavorites(movieId, userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeMovieFromFavorites(String userId, int movieId) async {
    try {
      await _firestoreService.removeMovieFromFavorites(userId, movieId);
      await _firestoreService.removeUserFromMovieFavorites(movieId, userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<int>> getUserFavoriteMovies(String userId) async {
    try {
      final user = await _firestoreService.getUser(userId);
      return user?.favoriteMovieIds ?? [];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserModel>> getUsersWhoFavoritedMovie(int movieId) async {
    try {
      return await _firestoreService.getUsersWhoFavoritedMovie(movieId);
    } catch (e) {
      rethrow;
    }
  }

  // ARKADAŞLIK
  Future<void> sendFriendRequest(String senderId, String receiverId) async {
    try {
      await _firestoreService.sendFriendRequest(senderId, receiverId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> acceptFriendRequest(
    String friendshipId,
    String userId,
    String friendId,
  ) async {
    try {
      await _firestoreService.acceptFriendRequest(friendshipId, userId, friendId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> rejectFriendRequest(String friendshipId) async {
    try {
      await _firestoreService.rejectFriendRequest(friendshipId);
    } catch (e) {
      rethrow;
    }
  }


  Future<List<FriendshipModel>> getPendingFriendRequests(String userId) async {
    try {
      return await _firestoreService.getPendingFriendRequests(userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserModel>> getFriends(String userId) async {
    try {
      return await _firestoreService.getFriends(userId);
    } catch (e) {
      rethrow;
    }
  }
}
