class Booking {
  final String id; // Assuming this is correctly parsed to int
  final String fullName;
  final String email;
  final String phoneNumber;
  final String venueName;
  final String location;
  final String date; // Assuming this is a string in 'YYYY-MM-DD' format
  final String time; // Assuming this is a string in 'HH:mm' format
  final String hours;
  final double totalPrice; // This should be a double
  final double downpayment; // This should also be a double
  final String status; // Assuming this is a string

  Booking({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.venueName,
    required this.location,
    required this.date,
    required this.time,
    required this.hours,
    required this.totalPrice,
    required this.downpayment,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'], // Parse the ID as an integer
      fullName: json['full_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      venueName: json['venue_name'],
      location: json['location'],
      date: json['date'],
      time: json['time'],
      hours: json['hours'],
      totalPrice: double.parse(json['total_price']), // Parse the total price as a double
      downpayment: double.parse(json['downpayment']), // Parse the downpayment as a double
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'venue_name': venueName,
      'location': location,
      'date': date,
      'time': time,
      'hours': hours,
      'total_price': totalPrice.toString(), // Convert to string for JSON
      'downpayment': downpayment.toString(), // Convert to string for JSON
      'status': status,
    };
  }

  toMap() {}
}
