abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String email; // Required parameter
  final String? userType; // Optional parameter
  final String full_name; // Changed to full_name

  LoginSuccess({
    required this.email,
    this.userType,
    required this.full_name, // Updated constructor parameter
  });

  // You can remove these if they're not used
  // String? get fullName => null; // Removed as it's not needed
  // get full_name => null; // Removed as it's not needed
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}

// New state for navigation to AdminScreen
class LoginNavigateToAdmin extends LoginState {}

class LoginNavigateToUser extends LoginState {}