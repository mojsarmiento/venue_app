import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venue_app/bloc/venue_event.dart';
import 'package:venue_app/bloc/venue_state.dart';
import 'package:venue_app/repository/venue_repository.dart';

class VenueBloc extends Bloc<VenueEvent, VenueState> {
  final VenueRepository venueRepository;

  VenueBloc({required this.venueRepository}) : super(VenueInitial()) {
    on<AddVenueEvent>(_onAddVenueEvent);
    on<FetchTotalVenues>(_onFetchTotalVenues); // Existing fetch event listener

  }

  Future<void> _onAddVenueEvent(AddVenueEvent event, Emitter<VenueState> emit) async {
    emit(VenueLoading());
    try {
      // Add the venue using the repository
      await venueRepository.addVenue(event.venue);
      emit(VenueSuccess()); // Emit success state after adding venue
    } catch (e) {
      emit(VenueError(message: e.toString())); // Emit error state with a message
    }
  }

  Future<void> _onFetchTotalVenues(FetchTotalVenues event, Emitter<VenueState> emit) async {
    emit(VenueLoading()); // Emit loading state
    try {
      // Fetch total venues from the repository
      final totalVenues = await venueRepository.fetchTotalVenues();
      emit(VenueTotalLoaded(totalVenues)); // Emit loaded state with total venues
    } catch (e) {
      emit(VenueError(message: e.toString())); // Emit error state with a message
    }
  }
}





