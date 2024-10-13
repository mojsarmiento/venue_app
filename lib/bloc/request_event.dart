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