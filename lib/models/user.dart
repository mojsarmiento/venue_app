class User {
  final String userId;
  final String fullName;
  final String email;
  final String userType;

  User({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.userType,
  });

  // Factory constructor for creating a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'], // Assuming 'id' is the key in your JSON
      fullName: json['full_name'], // Adjust according to your JSON keys
      email: json['email'],
      userType: json['user_type'], // Adjust according to your JSON keys
    );
  }

  // Method to convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId, // Use the same key as used in the API
      'full_name': fullName, // Match the keys used in the backend
      'email': email,
      'user_type': userType, // Match the keys used in the backend
    };
  }

  copyWith({required String fullName, required String email, required String userType}) {}
}
