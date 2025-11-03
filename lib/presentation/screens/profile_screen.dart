import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/favorites_cubit.dart';
import '../../cubit/user_cubit.dart';
import '../../data/models/movie_model.dart';
import '../../data/models/user_model.dart';
import '../handlers/favorite_handler.dart';
import '../widgets/common/error_widget.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/profile/profile_app_bar.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/profile_stats.dart';
import '../widgets/profile/profile_tabs.dart';
import 'favorites_screen.dart';
import 'login_screen.dart';
import 'movie_details_screen.dart';
import 'user_search_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId; // null means current user

  const ProfileScreen({super.key, this.userId});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeScreen();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initializeScreen() {
    final authState =
        context.read<AuthCubit>().state as Authenticated;
    final targetUserId = widget.userId ?? authState.user.id;

    context.read<UserCubit>().loadUser(targetUserId);
    context.read<FavoritesCubit>().loadFavorites(
      targetUserId,
    );
  }

  Future<void> _handleLogout() async {
    final confirmed = await _showLogoutDialog();
    if (confirmed == true) {
      await context.read<AuthCubit>().logout();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    }
  }

  Future<bool?> _showLogoutDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text('Çıkış Yap'),
        content: const Text(
          'Hesabınızdan çıkış yapmak istediğinizden emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(true),
            child: Text(
              'Çıkış Yap',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToSearchUsers() {
    final authState =
        context.read<AuthCubit>().state as Authenticated;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            UserSearchScreen(userId: authState.user.id),
      ),
    );
  }

  void _navigateToFavorites() {
    final authState =
        context.read<AuthCubit>().state as Authenticated;
    final targetUserId = widget.userId ?? authState.user.id;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            FavoritesScreen(userId: targetUserId),
      ),
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

  Future<void> _handleFavoritePress(
    MovieModel movie,
  ) async {
    await FavoriteHandler.handleFavoritePress(
      context,
      movie,
    );
  }

  bool _isOwnProfile(String userId) {
    final authState =
        context.read<AuthCubit>().state as Authenticated;
    return authState.user.id == userId;
  }

  @override
  Widget build(BuildContext context) {
    final authState =
        context.read<AuthCubit>().state as Authenticated;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildProfileContent(authState.user),
    );
  }

  Widget _buildProfileContent(UserModel currentUser) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        if (userState is UserLoading) {
          return const LoadingIndicator(
            message: 'Profil yükleniyor...',
          );
        }

        if (userState is UserError) {
          return CustomErrorWidget(
            message: userState.message,
            onRetry: () {
              final targetUserId =
                  widget.userId ?? currentUser.id;
              context.read<UserCubit>().loadUser(
                targetUserId,
              );
            },
          );
        }

        if (userState is UserLoaded) {
          final isOwnProfile = _isOwnProfile(
            userState.user.id,
          );

          return NestedScrollView(
            headerSliverBuilder:
                (context, innerBoxIsScrolled) {
                  return [
                    ProfileAppBar(
                      user: userState.user,
                      isOwnProfile: isOwnProfile,
                      onLogout: isOwnProfile
                          ? _handleLogout
                          : null,
                      onSearchUsers: isOwnProfile
                          ? _navigateToSearchUsers
                          : null,
                    ),
                  ];
                },
            body: Column(
              children: [
                ProfileHeader(
                  user: userState.user,
                  isOwnProfile: isOwnProfile,
                ),
                ProfileStats(
                  user: userState.user,
                  friendsCount: userState.friends.length,
                  onFavoritesPressed: _navigateToFavorites,
                  onFriendsPressed: () {
                    _tabController.animateTo(1);
                  },
                ),
                ProfileTabs(
                  tabController: _tabController,
                  user: userState.user,
                  isOwnProfile: isOwnProfile,
                  onMovieTap: _handleMovieTap,
                  onFavoritePress: _handleFavoritePress,
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
