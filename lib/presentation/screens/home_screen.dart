import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/auth_cubit.dart';
import '../../cubit/favorites_cubit.dart';
import '../../cubit/movie_cubit.dart';
import '../../data/models/movie_model.dart';
import '../handlers/favorite_handler.dart';
import '../widgets/home/category_chip_list.dart';
import '../widgets/home/home_app_bar_actions.dart';
import '../widgets/home/movie_grid.dart';
import 'movie_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  void _initializeScreen() {
    context.read<MovieCubit>().loadMovies(
      MovieCategory.popular,
    );

    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      context.read<FavoritesCubit>().loadFavorites(
        authState.user.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Movie Social'),
      actions: const [HomeAppBarActions()],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        const CategoryChipList(),
        const Divider(height: 1),
        Expanded(
          child: MovieGrid(
            onMovieTap: _handleMovieTap,
            onFavoriteTap: _handleFavoriteTap,
          ),
        ),
      ],
    );
  }

  void _handleMovieTap(MovieModel movie) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            MovieDetailsScreen(movie: movie),
      ),
    );
  }

  Future<void> _handleFavoriteTap(MovieModel movie) async {
    await FavoriteHandler.handleFavoritePress(
      context,
      movie,
    );
  }
}
