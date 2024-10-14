abstract class RequestEvent {}

class SubmitRequestEvent extends RequestEvent {
  final String venue;
  final String location;
  final String fullName;
  final String email;
  final String mobileNumber;
  final String date;
  final String time;

  SubmitRequestEvent({
    required this.venue,
    required this.location,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.date,
    required this.time,
  });
}

class FetchRequests extends RequestEvent {}

// New event for approving a request
class ApproveRequestEvent extends RequestEvent {
  final String id; // Assuming request ID is of type int

  ApproveRequestEvent(this.id);
}

// New event for rejecting a request
class RejectRequestEvent extends RequestEvent {
  final String id; // Assuming request ID is of type int

  RejectRequestEvent(this.id);
}

class FetchTotalRequest extends RequestEvent {}

class MarkAsDoneEvent extends RequestEvent {
  final String id;

  MarkAsDoneEvent(this.id);
}