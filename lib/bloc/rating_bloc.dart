
// lib/bloc/rating_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venue_app/repository/rating_repository.dart';
import 'rating_event.dart';
import 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final RatingRepository ratingRepository;

  RatingBloc({required this.ratingRepository}) : super(RatingInitial());

  Stream<RatingState> mapEventToState(RatingEvent event) async* {
    if (event is SubmitRatingEvent) {
      yield RatingSubmitting();
      try {
        final message = await ratingRepository.submitRating(
          event.venueId.toString(),
          event.rating,
        );
        yield RatingSubmittedSuccess(message);
      } catch (error) {
        yield RatingSubmittedFailure(error.toString());
      }
    }
  }
}
