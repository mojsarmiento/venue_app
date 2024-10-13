import 'package:venue_app/models/request.dart';

abstract class RequestState {}

// Initial state when the requests have not yet been loaded.
class RequestInitial extends RequestState {}

// State when requests are being loaded.
class RequestLoading extends RequestState {}

// State when requests are successfully loaded.
class RequestLoaded extends RequestState {
  final List<Request> requests;

  RequestLoaded(this.requests);
}

// State when a request is being submitted.
class RequestSubmitting extends RequestState {}

// State when a request has been successfully submitted.
class RequestSubmitted extends RequestState {
  final String message;

  RequestSubmitted(this.message);
}

// State when there's an error in loading or submitting requests.
class RequestError extends RequestState {
  final String message;

  RequestError(this.message);
}
