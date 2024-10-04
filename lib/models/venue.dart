class Venue {
  final String name;
  final String location;
  final List<String> images; // List of image paths or URLs
  final double pricePerHour;
  final String availability;
  final String suitableFor;
  final String additionalDetails;

  Venue({
    required this.name,
    required this.location,
    required this.images,
    required this.pricePerHour,
    required this.availability,
    required this.suitableFor,
    required this.additionalDetails,
  });
}
