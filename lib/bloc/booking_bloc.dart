import 'package:bloc/bloc.dart';
import 'package:venue_app/repository/booking_repository.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository bookingRepository;

  BookingBloc({required this.bookingRepository}) : super(BookingInitial()) {
    on<BookingEvent>((event, emit) async {
      if (event is FetchBookings) {
        emit(BookingLoading());
        try {
          final bookings = await bookingRepository.getBookings();
          final totalBookings = await bookingRepository.fetchTotalBookings(); // Fetch total bookings
          emit(BookingLoaded(bookings: bookings, totalBookings: totalBookings)); // Include total bookings
        } catch (e) {
          emit(BookingError('Failed to fetch bookings: $e'));
        }
      } else if (event is AddBooking) {
        emit(BookingLoading());
        try {
          await bookingRepository.createBooking(event.booking);
          final bookings = await bookingRepository.getBookings();
          final totalBookings = await bookingRepository.fetchTotalBookings(); // Fetch total bookings
          emit(BookingLoaded(bookings: bookings, totalBookings: totalBookings)); // Include total bookings
        } catch (e) {
          emit(BookingError('Failed to create booking: $e'));
        }
      }
    });
  }
}
