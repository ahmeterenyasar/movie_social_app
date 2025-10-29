import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/movie_favorite_model.dart';

// States
abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInital extends FavoritesState {}
class FavoritesLoading extends FavoritesState {}
class FavoritesLoaded extends FavoritesState {}
class FavoritesError extends FavoritesState {}

// Cubit
class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(super.initialState);
}