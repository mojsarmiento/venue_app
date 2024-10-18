import 'package:equatable/equatable.dart';
import 'package:venue_app/models/booking.dart';

abstract class BookingEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchBookings extends BookingEvent {}

class AddBooking extends BookingEvent {
  final Booking booking;

  AddBooking(this.booking);

  @override
  List<Object> get props => [booking];
}
