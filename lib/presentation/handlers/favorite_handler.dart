import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/auth_cubit.dart';
import '../../cubit/favorites_cubit.dart';
import '../../data/models/movie_model.dart';
import '../screens/login_screen.dart';

class FavoriteHandler {
  static Future<void> handleFavoritePress(
    BuildContext context,
    MovieModel movie,
  ) async {
    final authState = context.read<AuthCubit>().state;

    if (authState is! Authenticated) {
      _navigateToLogin(context);
      return;
    }

    await _toggleFavorite(context, authState.user.id, movie);
  }

  static void _navigateToLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  static Future<void> _toggleFavorite(
    BuildContext context,
    String userId,
    MovieModel movie,
  ) async {
    try {
      await context.read<FavoritesCubit>().toggleFavorite(userId, movie.id);
      
      if (context.mounted) {
        final isFavorite = context.read<FavoritesCubit>().isFavorite(movie.id);
        _showFeedbackMessage(context, isFavorite, movie.title);
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorMessage(context, e.toString());
      }
    }
  }

  static void _showFeedbackMessage(
    BuildContext context,
    bool isFavorite,
    String movieTitle,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite 
            ? '$movieTitle favorilere eklendi!' 
            : '$movieTitle favorilerden çıkarıldı!',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void _showErrorMessage(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Hata: $error'),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
