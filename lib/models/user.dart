// lib/models/user.dart

class User {
  final String fullName;
  final String email;
  final String password;
  final List<String> userTypes;

  User({
    required this.fullName,
    required this.email,
    required this.password,
    required this.userTypes,
  });
}
