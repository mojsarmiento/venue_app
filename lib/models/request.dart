class Request {
  final String id;
  final String venueName;
  final String location;
  final String fullName;
  final String email;
  final String mobileNumber;
  final String requestDate;
  final String requestTime;
  final String status; // Add status field

  Request({
    required this.id,
    required this.venueName,
    required this.location,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.requestDate,
    required this.requestTime,
    required this.status, // Include status in the constructor
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'],
      venueName: json['venue_name'] ?? 'Unknown Venue', // Default value
      location: json['location'] ?? 'Unknown Location', // Default value
      fullName: json['full_name'] ?? 'Unknown Name', // Default value
      email: json['email'] ?? 'unknown@example.com', // Default value
      mobileNumber: json['mobile_number'] ?? 'Unknown Number', // Default value
      requestDate: json['request_date'] ?? 'Unknown Date', // Default value
      requestTime: json['request_time'] ?? 'Unknown Time', // Default value
      status: json['status'] ?? 'Unknown Status',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'venue_name': venueName,
      'location': location,
      'full_name': fullName,
      'email': email,
      'mobile_number': mobileNumber,
      'request_date': requestDate,
      'request_time': requestTime,
      'status': status,
    };
  }
}
