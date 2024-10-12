class Venue {
  final String venueId; // Rename to venueId for clarity
  final String name;
  final String location;
  final List<String> images;
  final double pricePerHour;
  final String availability;
  final String category;
  final String additionalDetails;
  final List<double> ratings;

  Venue({
    required this.venueId, // Include venueId in the constructor
    required this.name,
    required this.location,
    required this.images,
    required this.pricePerHour,
    required this.availability,
    required this.category,
    required this.additionalDetails,
    required this.ratings,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      venueId: json['venue_id'], // Ensure this matches your database column name
      name: json['name'],
      location: json['location'],
      images: List<String>.from(json['images'] ?? []), // Handle null gracefully
      pricePerHour: json['pricePerHour']?.toDouble() ?? 0.0, // Default to 0.0 if null
      availability: json['availability'],
      category: json['category'],
      additionalDetails: json['additionalDetails'],
      ratings: List<double>.from(json['ratings']?.map((x) => x.toDouble()) ?? []), // Handle null gracefully
    );
  }

  // Calculate the average rating
  double getAverageRating() {
    if (ratings.isEmpty) return 0.0; // Return 0 if no ratings
    final total = ratings.reduce((a, b) => a + b);
    return total / ratings.length; // Calculate average
  }

  Map<String, dynamic> toJson() {
    return {
      'venue_id': venueId, // Serialize the venue_id
      'name': name,
      'location': location,
      'images': images,
      'price_per_hour': pricePerHour,
      'availability': availability,
      'category': category,
      'additional_details': additionalDetails,
      'ratings': ratings,
    };
  }
}




