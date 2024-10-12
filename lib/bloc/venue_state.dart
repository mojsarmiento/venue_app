abstract class VenueState {}

class VenueInitial extends VenueState {}

class VenueLoading extends VenueState {}

class VenueSuccess extends VenueState {}

class VenueError extends VenueState {
  final String message;

  VenueError({required this.message}); // Constructor with required message parameter
}



