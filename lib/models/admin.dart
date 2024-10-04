class Admin {
  final String userId;
  final String fullName;
  final String email;

  Admin({
    required this.userId,
    required this.fullName,
    required this.email,
  });

  // Factory method to create an Admin instance from a JSON map
  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      userId: json['userId'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
    );
  }

  // Method to convert an Admin instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'full_name': fullName,
      'email': email,
    };
  }
}
