// lib/bloc/rating_event.dart
// lib/bloc/rating_event.dart

abstract class RatingEvent {}

class SubmitRatingEvent extends RatingEvent {
  final int venueId;
  final double rating;

  SubmitRatingEvent({
    required this.venueId,
    required this.rating,
  });
}
