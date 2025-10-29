import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// States
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInital extends UserState {}
class UserLoading extends UserState {}
class UserLoaded extends UserState {}
class UserError extends UserState {}

// Cubit

class UserCubit extends Cubit<UserState> {
  UserCubit(super.initialState);
  
}