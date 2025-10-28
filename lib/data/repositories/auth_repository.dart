import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_service.dart';

class AuthRepository {
  final FirebaseAuthService _authService;
  final FirestoreService _firestoreService;

  AuthRepository({
    FirebaseAuthService? authService,
    FirestoreService? firestoreService,
  })  : _authService = authService ?? FirebaseAuthService(),
        _firestoreService = firestoreService ?? FirestoreService();

  Stream<User?> get authStateChanges => _authService.authStateChanges;
  String? get currentUserId => _authService.currentUserId;
  bool get isSignedIn => _authService.isSignedIn;

  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String nickname,
    required String email,
    required String password,
  }) async {
    try {
      final isAvailable = await _firestoreService.isNicknameAvailable(nickname);
      if (!isAvailable) {
        throw Exception('Bu kullanıcı adı zaten kullanılıyor');
      }

      final userId = await _authService.signUpWithEmailPassword(
        email: email,
        password: password,
      );

      final user = UserModel(
        id: userId,
        firstName: firstName,
        lastName: lastName,
        nickname: nickname,
        email: email,
        favoriteMovieIds: [],
        friendIds: [],
        createdAt: DateTime.now(),
      );

      await _firestoreService.createUser(user);

      return user;
    } catch (e) {
      if (_authService.isSignedIn) {
        await _authService.signOut();
      }
      rethrow;
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final userId = await _authService.signInWithEmailPassword(
        email: email,
        password: password,
      );

      final user = await _firestoreService.getUser(userId);
      if (user == null) {
        throw Exception('Kullanıcı bilgileri bulunamadı');
      }

      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final userId = _authService.currentUserId;
      if (userId == null) return null;

      return await _firestoreService.getUser(userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _authService.deleteAccount();
    } catch (e) {
      rethrow;
    }
  }
}
