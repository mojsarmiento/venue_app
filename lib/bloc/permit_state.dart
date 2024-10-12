// permit_state.dart
part of 'permit_bloc.dart';

abstract class BeAVenueOwnerState extends Equatable {
  const BeAVenueOwnerState();

  @override
  List<Object> get props => [];
}

class BeAVenueOwnerInitial extends BeAVenueOwnerState {}

class BeAVenueOwnerSubmitted extends BeAVenueOwnerState {
  final String message;

  const BeAVenueOwnerSubmitted(this.message);

  @override
  List<Object> get props => [message];
}

class BeAVenueOwnerError extends BeAVenueOwnerState {
  final String error;

  const BeAVenueOwnerError(this.error);

  @override
  List<Object> get props => [error];
}
