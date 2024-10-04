abstract class LoginState {}

class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {
  final String email; // Required parameter
  final String? userType; // Optional parameter

  LoginSuccess({required this.email, this.userType});
}
class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}

// New state for navigation to AdminScreen
class LoginNavigateToAdmin extends LoginState {}