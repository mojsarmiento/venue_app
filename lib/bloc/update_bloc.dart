import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venue_app/repository/venue_repository.dart';
import 'update_event.dart';
import 'update_state.dart';

class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
  final VenueRepository venueRepository; // Add a field for the repository

  UpdateBloc(this.venueRepository) : super(UpdateInitial());

  Stream<UpdateState> mapEventToState(UpdateEvent event) async* {
    if (event is UpdateVenueEvent) {
      yield UpdateLoading();

      try {
        // Call the repository's update method
        await venueRepository.updateVenue(event.venue);

        // Emit success state after update
        yield UpdateSuccess();
      } catch (e) {
        // Emit error state if something goes wrong
        yield UpdateError('Failed to update venue: $e');
      }
    }
  }
}


