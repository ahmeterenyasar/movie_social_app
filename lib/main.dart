import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'data/repositories/auth_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App',
      home: const TestScreen(),
    );
  }
}

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final AuthRepository _authRepo = AuthRepository();
  String _message = 'Henüz test yapılmadı';
  bool _loading = false;

  Future<void> _testRegister() async {
    setState(() => _loading = true);

    try {
      print('1. Kayıt başlatılıyor...');
      
      final user = await _authRepo.register(
        firstName: 'Ahmet',
        lastName: 'Akyüz',
        nickname: 'test',
        email: 'test@example.com',
        password: '123456',
      );

      print('2. Kayıt başarılı: ${user.id}');

      setState(() {
        _message = 'BAŞARILI!\nKullanıcı: ${user.fullName}\nNickname: ${user.nickname}\nEmail: ${user.email}';
        _loading = false;
      });
    } catch (e, stackTrace) {
      print('HATA DETAYI:');
      print('Hata: $e');
      print('StackTrace: $stackTrace');
      
      setState(() {
        _message = 'HATA:\n\nKonsola bak!!!!';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Test')),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _testRegister,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                      ),
                      child: const Text('KAYIT TESTİ YAP'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}