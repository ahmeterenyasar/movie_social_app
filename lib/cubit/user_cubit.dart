import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/friendship_model.dart';
import '../data/models/user_model.dart';
import '../data/repositories/user_repository.dart';

// States
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserModel user;
  final List<UserModel> friends;
  final List<FriendshipModel> pendingRequests;
  final Map<String, UserModel> pendingRequestSenders;

  const UserLoaded({
    required this.user,
    this.friends = const [],
    this.pendingRequests = const [],
    this.pendingRequestSenders = const {},
  });

  @override
  List<Object?> get props => [
    user,
    friends,
    pendingRequests,
    pendingRequestSenders,
  ];

  UserLoaded copyWith({
    UserModel? user,
    List<UserModel>? friends,
    List<FriendshipModel>? pendingRequests,
    Map<String, UserModel>? pendingRequestSenders,
  }) {
    return UserLoaded(
      user: user ?? this.user,
      friends: friends ?? this.friends,
      pendingRequests: pendingRequests ?? this.pendingRequests,
      pendingRequestSenders:
          pendingRequestSenders ??
          this.pendingRequestSenders,
    );
  }
}

class UserSearchLoading extends UserState {}

class UserSearchLoaded extends UserState {
  final List<UserModel> users;
  final String query;
  final List<String> friendIds;
  final List<String> pendingRequestSenderIds;
  final List<String> sentRequestReceiverIds;

  const UserSearchLoaded({
    required this.users,
    required this.query,
    this.friendIds = const [],
    this.pendingRequestSenderIds = const [],
    this.sentRequestReceiverIds = const [],
  });

  @override
  List<Object?> get props => [
    users,
    query,
    friendIds,
    pendingRequestSenderIds,
    sentRequestReceiverIds,
  ];

  bool isFriend(String userId) =>
      friendIds.contains(userId);
  bool hasPendingRequestFrom(String userId) =>
      pendingRequestSenderIds.contains(userId);
  bool hasSentRequestTo(String userId) =>
      sentRequestReceiverIds.contains(userId);
}

class UserSearchError extends UserState {
  final String message;

  const UserSearchError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}

class FriendRequestSent extends UserState {
  final String receiverId;

  const FriendRequestSent(this.receiverId);

  @override
  List<Object?> get props => [receiverId];
}

class FriendRequestAccepted extends UserState {
  final String friendId;

  const FriendRequestAccepted(this.friendId);

  @override
  List<Object?> get props => [friendId];
}

// Cubit
class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;

  UserCubit({
    UserRepository? userRepository,
  })  : _userRepository = userRepository ?? UserRepository(),
        super(UserInitial());

  Future<void> loadUser(String userId) async {
    emit(UserLoading());

    try {
      final user = await _userRepository.getUser(userId);
      if (user == null) {
        emit(const UserError('Kullanıcı bulunamadı'));
        return;
      }

      emit(UserLoaded(user: user));

      _loadUserRelations(userId);
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _loadUserRelations(String userId) async {
    try {
      final currentState = state;
      if (currentState is! UserLoaded) return;

      final results = await Future.wait([
        _userRepository.getFriends(userId),
        _userRepository.getPendingFriendRequests(userId),
      ]);

      final friends = results[0] as List<UserModel>;
      final pendingRequests =
          results[1] as List<FriendshipModel>;

      // Load sender user info for each pending request
      final senderUsers = <String, UserModel>{};
      for (final request in pendingRequests) {
        try {
          final senderUser = await _userRepository.getUser(
            request.senderId,
          );
          if (senderUser != null) {
            senderUsers[request.senderId] = senderUser;
          }
        } catch (e) {
          print(
            'Sender user yüklenemedi: ${request.senderId}',
          );
        }
      }

      emit(currentState.copyWith(
          friends: friends,
          pendingRequests: pendingRequests,
          pendingRequestSenders: senderUsers,
      ));
    } catch (e) {
      print('Kullanıcı ilişkileri yüklenemedi: $e');
    }
  }

  Future<void> refreshUser(String userId) async {
    try {
      final user = await _userRepository.getUser(userId);
      if (user == null) return;

      final currentState = state;
      if (currentState is UserLoaded) {
        emit(currentState.copyWith(user: user));
      } else {
        emit(UserLoaded(user: user));
      }
    } catch (e) {
      print('Kullanıcı yenilenemedi: $e');
    }
  }

  Future<void> loadFriends(String userId) async {
    try {
      final friends = await _userRepository.getFriends(userId);
      
      final currentState = state;
      if (currentState is UserLoaded) {
        emit(currentState.copyWith(friends: friends));
      }
    } catch (e) {
      print('Arkadaşlar yüklenemedi: $e');
    }
  }

  Future<void> loadPendingRequests(String userId) async {
    try {
      final requests = await _userRepository.getPendingFriendRequests(userId);
      
      // Load sender user info for each request
      final senderUsers = <String, UserModel>{};
      for (final request in requests) {
        try {
          final senderUser = await _userRepository.getUser(
            request.senderId,
          );
          if (senderUser != null) {
            senderUsers[request.senderId] = senderUser;
          }
        } catch (e) {
          print(
            'Sender user yüklenemedi: ${request.senderId}',
          );
        }
      }
      
      final currentState = state;
      if (currentState is UserLoaded) {
        emit(
          currentState.copyWith(
            pendingRequests: requests,
            pendingRequestSenders: senderUsers,
          ),
        );
      }
    } catch (e) {
      print('Bekleyen istekler yüklenemedi: $e');
    }
  }

  Future<void> searchUsers(
    String query,
    String currentUserId,
  ) async {
    if (query.trim().isEmpty) {
      emit(UserInitial());
      return;
    }

    emit(UserSearchLoading());

    try {
      final users = await _userRepository.searchUsers(query);
      
      // Get current user's friendship info
      final currentUser = await _userRepository.getUser(
        currentUserId,
      );
      final friendIds = currentUser?.friendIds ?? [];

      // Get pending requests (received)
      final pendingRequests = await _userRepository
          .getPendingFriendRequests(currentUserId);
      final pendingRequestSenderIds = pendingRequests
          .map((req) => req.senderId)
          .toList();

      // Get sent requests (sent by current user)
      final sentRequests = await _userRepository
          .getSentFriendRequests(currentUserId);
      final sentRequestReceiverIds = sentRequests
          .map((req) => req.receiverId)
          .toList();

      emit(
        UserSearchLoaded(
          users: users,
          query: query,
          friendIds: friendIds,
          pendingRequestSenderIds: pendingRequestSenderIds,
          sentRequestReceiverIds: sentRequestReceiverIds,
        ),
      );
    } catch (e) {
      emit(UserSearchError(e.toString()));
    }
  }

  Future<void> sendFriendRequest(String senderId, String receiverId) async {
    try {
      await _userRepository.sendFriendRequest(senderId, receiverId);
      emit(FriendRequestSent(receiverId));
      
      Future.delayed(const Duration(milliseconds: 500), () {
        loadUser(senderId);
      });
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> acceptFriendRequest(
    String friendshipId,
    String userId,
    String friendId,
  ) async {
    try {
      await _userRepository.acceptFriendRequest(friendshipId, userId, friendId);
      emit(FriendRequestAccepted(friendId));
      
      Future.delayed(const Duration(milliseconds: 500), () {
        loadUser(userId);
      });
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> rejectFriendRequest(String friendshipId, String userId) async {
    try {
      await _userRepository.rejectFriendRequest(friendshipId);
      
      await loadPendingRequests(userId);
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _userRepository.updateUser(user);
      
      final currentState = state;
      if (currentState is UserLoaded) {
        emit(currentState.copyWith(user: user));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  void clearSearch() {
    emit(UserInitial());
  }

  void reset() {
    emit(UserInitial());
  }

  // Getters
  UserModel? get currentUser {
    final currentState = state;
    if (currentState is UserLoaded) {
      return currentState.user;
    }
    return null;
  }

  List<UserModel> get friends {
    final currentState = state;
    if (currentState is UserLoaded) {
      return currentState.friends;
    }
    return [];
  }

  List<FriendshipModel> get pendingRequests {
    final currentState = state;
    if (currentState is UserLoaded) {
      return currentState.pendingRequests;
    }
    return [];
  }

  bool isFriend(String userId) {
    final currentState = state;
    if (currentState is UserLoaded) {
      return currentState.friends.any((friend) => friend.id == userId);
    }
    return false;
  }

  bool hasPendingRequest(String senderId) {
    final currentState = state;
    if (currentState is UserLoaded) {
      return currentState.pendingRequests.any(
        (request) => request.senderId == senderId,
      );
    }
    return false;
  }
}
