import 'package:equatable/equatable.dart';
import 'package:venue_app/models/user.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Event to fetch user count
class FetchUserCountEvent extends UserEvent {}

class FetchUsersEvent extends UserEvent {} // Add this line for fetching users

class DeleteUserEvent extends UserEvent {
  final String userId;

  DeleteUserEvent(this.userId);
}

class UpdateUserEvent extends UserEvent {
  final User user;

  UpdateUserEvent(this.user);
}
