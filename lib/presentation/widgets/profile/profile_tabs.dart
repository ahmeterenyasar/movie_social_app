import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_colors.dart';
import '../../../cubit/favorites_cubit.dart';
import '../../../cubit/user_cubit.dart';
import '../../../data/models/movie_model.dart';
import '../../../data/models/user_model.dart';
import '../common/empty_state_widget.dart';
import '../common/loading_indicator.dart';
import 'profile_favorites_tab.dart';
import 'profile_friends_tab.dart';

class ProfileTabs extends StatelessWidget {
  final TabController tabController;
  final UserModel user;
  final bool isOwnProfile;
  final Function(MovieModel) onMovieTap;
  final Function(MovieModel) onFavoritePress;

  const ProfileTabs({
    super.key,
    required this.tabController,
    required this.user,
    required this.isOwnProfile,
    required this.onMovieTap,
    required this.onFavoritePress,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                _buildFavoritesTab(context),
                _buildFriendsTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: TabBar(
        controller: tabController,
        indicatorColor: AppColors.accent,
        labelColor: AppColors.accent,
        unselectedLabelColor: AppColors.textSecondary,
        tabs: const [
          Tab(icon: Icon(Icons.movie), text: 'Favoriler'),
          Tab(icon: Icon(Icons.people), text: 'Arkadaşlar'),
        ],
      ),
    );
  }

  Widget _buildFavoritesTab(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        if (state is FavoritesLoading) {
          return const LoadingIndicator(message: 'Favoriler yükleniyor...');
        }

        if (state is FavoritesLoaded) {
          if (state.movies.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.movie_outlined,
              title: 'Henüz Favori Yok',
              message: isOwnProfile
                  ? 'Beğendiğiniz filmleri favorilerinize ekleyin'
                  : '${user.firstName} henüz favori eklememis',
            );
          }

          return ProfileFavoritesTab(
            movies: state.movies,
            favoriteMovieIds: state.favoriteMovieIds,
            onMovieTap: onMovieTap,
            onFavoritePress: onFavoritePress,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFriendsTab(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          if (state.friends.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.people_outlined,
              title: 'Henüz Arkadaş Yok',
              message: isOwnProfile
                  ? 'Kullanıcı arayarak arkadaş ekleyin'
                  : '${user.firstName} henüz arkadaş eklememiş',
            );
          }

          return ProfileFriendsTab(friends: state.friends);
        }

        return const SizedBox.shrink();
      },
    );
  }
}
