import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../cubit/user_cubit.dart';
import '../widgets/common/empty_state_widget.dart';
import '../widgets/common/error_widget.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/user_search/pending_requests_section.dart';
import '../widgets/user_search/search_bar_widget.dart';
import '../widgets/user_search/user_search_list.dart';
import 'profile_screen.dart';

class UserSearchScreen extends StatefulWidget {
  final String userId;

  const UserSearchScreen({super.key, required this.userId});

  @override
  State<UserSearchScreen> createState() =>
      _UserSearchScreenState();
}

class _UserSearchScreenState
    extends State<UserSearchScreen> {
  final TextEditingController _searchController =
      TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showPendingRequests = false;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _initializeScreen() {
    context.read<UserCubit>().loadPendingRequests(
      widget.userId,
    );
  }

  void _handleSearch(String query) {
    if (query.trim().isEmpty) {
      context.read<UserCubit>().clearSearch();
      return;
    }

    context.read<UserCubit>().searchUsers(
      query.trim(),
      widget.userId,
    );
  }

  void _togglePendingRequests() {
    setState(() {
      _showPendingRequests = !_showPendingRequests;
    });
  }

  Future<void> _handleSendFriendRequest(
    String receiverId,
  ) async {
    await context.read<UserCubit>().sendFriendRequest(
      widget.userId,
      receiverId,
    );

    if (mounted) {
      _showSuccessMessage('Arkadaşlık isteği gönderildi');
    }
  }

  Future<void> _handleAcceptRequest(
    String friendshipId,
    String friendId,
  ) async {
    await context.read<UserCubit>().acceptFriendRequest(
      friendshipId,
      widget.userId,
      friendId,
    );

    if (mounted) {
      _showSuccessMessage('Arkadaşlık isteği kabul edildi');
      context.read<UserCubit>().loadPendingRequests(
        widget.userId,
      );
    }
  }

  Future<void> _handleRejectRequest(
    String friendshipId,
  ) async {
    await context.read<UserCubit>().rejectFriendRequest(
      friendshipId,
      widget.userId,
    );

    if (mounted) {
      _showSuccessMessage('Arkadaşlık isteği reddedildi');
    }
  }

  void _handleNavigateToProfile(String userId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfileScreen(userId: userId),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: _buildContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: const Text('Kullanıcı Ara'),
      centerTitle: true,
      actions: [
        /* pending requests notification button section */
        BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            int pendingCount = 0;
            if (state is UserLoaded) {
              pendingCount = state.pendingRequests.length;
            }

            return Stack(
              children: [
                IconButton(
                  icon: Icon(
                    _showPendingRequests
                        ? Icons.search
                        : Icons.notifications_outlined,
                  ),
                  onPressed: _togglePendingRequests,
                  tooltip: _showPendingRequests
                      ? 'Aramaya Dön'
                      : 'Bekleyen İstekler',
                ),
                /* request counting */
                if (pendingCount > 0 &&
                    !_showPendingRequests)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        pendingCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        if (!_showPendingRequests)
          SearchBarWidget(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onChanged: _handleSearch,
          ),

        Expanded(
          child: _showPendingRequests
              ? _buildPendingRequestsView()
              : _buildSearchResultsView(),
        ),
      ],
    );
  }

  Widget _buildPendingRequestsView() {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          return PendingRequestsSection(
            currentUserId: widget.userId,
            pendingRequests: state.pendingRequests,
            senderUsers: state.pendingRequestSenders,
            onAccept: _handleAcceptRequest,
            onReject: _handleRejectRequest,
            onUserTap: _handleNavigateToProfile,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSearchResultsView() {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserError) {
          _showErrorMessage(state.message);
        }
      },
      builder: (context, state) {
        if (state is UserSearchLoading) {
          return const LoadingIndicator(
            message: 'Kullanıcılar aranıyor...',
          );
        }

        if (state is UserSearchError) {
          return CustomErrorWidget(
            message: state.message,
            onRetry: () =>
                _handleSearch(_searchController.text),
          );
        }

        if (state is UserSearchLoaded) {
          if (state.users.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.person_off_outlined,
              title: 'Kullanıcı Bulunamadı',
              message:
                  '"${state.query}" için sonuç bulunamadı',
            );
          }

          return UserSearchList(
            currentUserId: widget.userId,
            users: state.users,
            onSendRequest: _handleSendFriendRequest,
            onUserTap: _handleNavigateToProfile,
          );
        }

        /* search prompt */
        return EmptyStateWidget(
          icon: Icons.person_search,
          title: 'Kullanıcı Ara',
          message:
              'Kullanıcı adı ile arama yaparak yeni arkadaşlar ekleyin',
        );
      },
    );
  }
}
