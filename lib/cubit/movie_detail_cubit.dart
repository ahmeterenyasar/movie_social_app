import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


// States
abstract class MovieDetailState extends Equatable {
  const MovieDetailState();
  @override
  List<Object?> get props => [];
}

class MovieDetailInitial extends MovieDetailState {}
class MovieDetailLoading extends MovieDetailState {}
class MovieDetailLoaded extends MovieDetailState {}
class MovieDetailError extends MovieDetailState {}


// Cubit
class MovieDetailCubit extends Cubit<MovieDetailState> {
  MovieDetailCubit(super.initialState);
  
}
