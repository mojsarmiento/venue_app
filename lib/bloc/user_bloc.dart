import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venue_app/bloc/user_event.dart';
import 'package:venue_app/bloc/user_state.dart';
import 'package:venue_app/repository/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    // Event listeners
    on<FetchUserCountEvent>(_onFetchUserCount);
    on<FetchUsersEvent>(_onFetchUsers);
    on<DeleteUserEvent>(_onDeleteUser);
    on<UpdateUserEvent>(_onEditUser); // Add event listener for editing a user
  }

  // Handle FetchUserCountEvent
  Future<void> _onFetchUserCount(FetchUserCountEvent event, Emitter<UserState> emit) async {
    emit(UserLoading()); // Emit loading state
    try {
      final userCount = await userRepository.fetchUserCount();
      emit(UserCountLoaded(userCount)); // Emit loaded state with user count
    } catch (e) {
      emit(UserError(message: e.toString())); // Emit error state with a message
    }
  }

  // Handle FetchUsersEvent
  Future<void> _onFetchUsers(FetchUsersEvent event, Emitter<UserState> emit) async {
    emit(UserLoading()); // Emit loading state
    try {
      final users = await userRepository.fetchUsers();
      emit(UserLoaded(users)); // Emit loaded state with the list of users
    } catch (e) {
      emit(UserError(message: e.toString())); // Emit error state with a message
    }
  }

  // Handle DeleteUserEvent
  Future<void> _onDeleteUser(DeleteUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading()); // Emit loading state
    try {
      await userRepository.deleteUser(event.userId); // Call the delete method
      add(FetchUsersEvent()); // Fetch the updated list of users
      emit(UserDeleted('User deleted successfully!')); // Emit a success message
    } catch (e) {
      emit(UserError(message: e.toString())); // Emit error state
    }
  }

  // Handle EditUserEvent
  Future<void> _onEditUser(UpdateUserEvent event, Emitter<UserState> emit) async {
  emit(UserLoading()); // Emit loading state
  try {
    await userRepository.updateUser(event.user); // Call the update method
    add(FetchUsersEvent()); // Fetch the updated list of users
    emit(UserEdited(user: event.user));

    // Show success message
    emit(UpdateUserSuccess(message: 'User updated successfully!')); // Emit success state
  } catch (e) {
    emit(UserError(message: e.toString())); // Emit error state
  }
}

}
