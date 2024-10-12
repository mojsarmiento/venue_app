// permit_event.dart
part of 'permit_bloc.dart';

abstract class BeAVenueOwnerEvent extends Equatable {
  const BeAVenueOwnerEvent();

  @override
  List<Object> get props => [];
}

class UploadPermitEvent extends BeAVenueOwnerEvent {
  final File businessPermit;

  const UploadPermitEvent(this.businessPermit);

  @override
  List<Object> get props => [businessPermit];
}

