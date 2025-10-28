import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum FriendshipStatus {
  pending,
  accepted,
  rejected,
}

class FriendshipModel extends Equatable {
  const FriendshipModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String senderId;
  final String receiverId;
  final FriendshipStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory FriendshipModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FriendshipModel(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      status: _statusFromString(data['status'] ?? 'pending'),
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  factory FriendshipModel.fromMap(Map<String, dynamic> map, String id) {
    return FriendshipModel(
      id: id,
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      status: _statusFromString(map['status'] ?? 'pending'),
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'status': _statusToString(status),
      'createdAt': createdAt != null 
          ? Timestamp.fromDate(createdAt!) 
          : FieldValue.serverTimestamp(),
      'updatedAt': updatedAt != null 
          ? Timestamp.fromDate(updatedAt!) 
          : FieldValue.serverTimestamp(),
    };
  }

  static FriendshipStatus _statusFromString(String status) {
    switch (status) {
      case 'accepted':
        return FriendshipStatus.accepted;
      case 'rejected':
        return FriendshipStatus.rejected;
      default:
        return FriendshipStatus.pending;
    }
  }

  static String _statusToString(FriendshipStatus status) {
    switch (status) {
      case FriendshipStatus.accepted:
        return 'accepted';
      case FriendshipStatus.rejected:
        return 'rejected';
      case FriendshipStatus.pending:
        return 'pending';
    }
  }

  FriendshipModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    FriendshipStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FriendshipModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        senderId,
        receiverId,
        status,
        createdAt,
        updatedAt,
      ];
}
