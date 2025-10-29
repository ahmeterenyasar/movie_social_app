import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'data/repositories/movie_repository.dart';

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
      title: 'Movie Test',
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
  final MovieRepository _movieRepo = MovieRepository();
  String _message = 'Test yapmak için butona bas';
  bool _loading = false;

  Future<void> _testMovies() async {
    setState(() {
      _loading = true;
      _message = 'Filmler yükleniyor...';
    });

    try {
      final movies = await _movieRepo.getPopularMovies();

      setState(() {
        _loading = false;
        _message = '${movies.length} film yüklendi\n\n'
            'filmler:\n'
            '1. ${movies[0].title}\n'
            '2. ${movies[1].title}\n'
            '3. ${movies[2].title}\n'
            '20. ${movies[19].title}';
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _message = 'HATA!!!!!:\n$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TMDB API Test')),
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
                      onPressed: _testMovies,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                      ),
                      child: const Text('FİLM YÜKLE'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}