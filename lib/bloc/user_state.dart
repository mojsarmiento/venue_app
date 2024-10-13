import 'package:equatable/equatable.dart';
import 'package:venue_app/models/user.dart';

abstract class UserState extends Equatable {
  @override
  List<Object> get props => [];
}

// Initial state
class UserInitial extends UserState {}

// Loading state
class UserLoading extends UserState {}

// Error state
class UserError extends UserState {
  final String message;

  UserError({required this.message});

  @override
  List<Object> get props => [message];
}

// Loaded state for a list of users
class UserLoaded extends UserState {
  final List<User> users; // Assuming you have a User model

  UserLoaded(this.users);

  @override
  List<Object> get props => [users];
}

// Loaded state for user count
class UserCountLoaded extends UserState {
  final int userCount;

  UserCountLoaded(this.userCount);

  @override
  List<Object> get props => [userCount];
}

// State for successful user deletion
class UserDeleted extends UserState {
  final String message;

  UserDeleted(this.message);

  @override
  List<Object> get props => [message];
}

// State for successful user edit
class UserEdited extends UserState {
  final User user;

  UserEdited({required this.user});

  @override
  List<Object> get props => [user];
}

class UpdateUserSuccess extends UserState {
  final String message;

  UpdateUserSuccess({required this.message});
}
