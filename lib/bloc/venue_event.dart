import 'package:venue_app/models/venue.dart';

abstract class VenueEvent {}

class AddVenueEvent extends VenueEvent {
  final Venue venue;

  AddVenueEvent(this.venue);
}


class FetchTotalVenues extends VenueEvent {}
