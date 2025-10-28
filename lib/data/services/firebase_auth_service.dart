import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  bool get isSignedIn => _auth.currentUser != null;

  Future<String> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Kullanıcı oluşturulamadı');
      }
      return userCredential.user!.uid;
    } on FirebaseAuthException catch (e) {
      throw (_handleAuthException(e));
    } catch (e) {
      throw Exception('Kayıt sırasında bir hata oluştu: $e');
    }
  }

  Future<String> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Giriş yapılamadı');
      }

      return userCredential.user!.uid;
    } on FirebaseAuthException catch (e) {
      throw (_handleAuthException(e));
    } catch (e) {
      throw Exception('Giriş sırasında bir hata oluştu: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Çıkış yapılırken bir hata oluştu: $e');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw (_handleAuthException(e));
    } catch (e) {
      throw Exception('Şifre sıfırlama e-postası gönderilemedi: $e');
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw (_handleAuthException(e));
    } catch (e) {
      throw Exception('Hesap silinirken bir hata oluştu: $e');
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Şifre çok zayıf. En az 6 karakter olmalıdır.';
      case 'email-already-in-use':
        return 'Bu e-posta adresi zaten kullanılıyor.';
      case 'invalid-email':
        return 'Geçersiz e-posta adresi.';
      case 'operation-not-allowed':
        return 'Bu işlem şu anda devre dışı.';
      case 'user-disabled':
        return 'Bu kullanıcı hesabı devre dışı bırakılmış.';
      case 'user-not-found':
        return 'Bu e-posta ile kayıtlı kullanıcı bulunamadı.';
      case 'wrong-password':
        return 'Hatalı şifre.';
      case 'too-many-requests':
        return 'Çok fazla başarısız deneme. Lütfen daha sonra tekrar deneyin.';
      case 'network-request-failed':
        return 'İnternet bağlantısı hatası.';
      default:
        return 'Bir hata oluştu: ${e.message}';
    }
  }
}
