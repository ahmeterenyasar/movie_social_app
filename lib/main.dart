import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'constants/app_theme.dart';
import 'cubit/auth_cubit.dart';
import 'cubit/movie_cubit.dart';
import 'cubit/favorites_cubit.dart';
import 'cubit/movie_detail_cubit.dart';
import 'cubit/user_cubit.dart';
import 'presentation/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // temporary
    // mutli provider section will be changed. every cubit will be transferred to corresponding section
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => MovieCubit()),
        BlocProvider(create: (context) => FavoritesCubit()),
        BlocProvider(create: (context) => MovieDetailCubit()),
        BlocProvider(create: (context) => UserCubit()),
      ],
      child: MaterialApp(
        title: 'Movie Social App',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
