import 'package:equatable/equatable.dart';
import 'package:venue_app/models/booking.dart';

abstract class BookingState extends Equatable {
  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<Booking> bookings;
  final int totalBookings; // Add this field

  BookingLoaded({required this.bookings, required this.totalBookings}); // Update the constructor

  @override
  List<Object> get props => [bookings, totalBookings]; // Include totalBookings in props
}

class BookingError extends BookingState {
  final String error;

  BookingError(this.error);

  @override
  List<Object> get props => [error];
}
