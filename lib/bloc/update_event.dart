// venue_event.dart
// update_event.dart

import 'package:venue_app/models/venue.dart';

abstract class UpdateEvent {}

class UpdateVenueEvent extends UpdateEvent {
  final Venue venue;

  UpdateVenueEvent(this.venue);
}
