// permit_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:io'; // Ensure you import File
import 'package:venue_app/repository/venue_repository.dart'; // Adjust the import as necessary

part 'permit_event.dart';
part 'permit_state.dart';

class BeAVenueOwnerBloc extends Bloc<BeAVenueOwnerEvent, BeAVenueOwnerState> {
  final VenueRepository venueRepository;

  BeAVenueOwnerBloc({required this.venueRepository}) : super(BeAVenueOwnerInitial()) {
    on<UploadPermitEvent>((event, emit) async {
      try {
        // Simulate a network request or file upload process here
        await venueRepository.uploadPermit(event.businessPermit); // This should be defined in your repository
        
        emit(const BeAVenueOwnerSubmitted('Business permit uploaded successfully.'));
      } catch (error) {
        emit(BeAVenueOwnerError('Failed to upload business permit: $error'));
      }
    });
  }
}

