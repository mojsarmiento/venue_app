// lib/bloc/rating_state.dart

abstract class RatingState {}

class RatingInitial extends RatingState {}

class RatingSubmitting extends RatingState {}

class RatingSubmittedSuccess extends RatingState {
  final String message;

  RatingSubmittedSuccess(this.message);
}

class RatingSubmittedFailure extends RatingState {
  final String error;

  RatingSubmittedFailure(this.error);
}
