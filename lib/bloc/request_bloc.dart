// request_bloc.dart
import 'dart:convert';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venue_app/repository/request_repository.dart';
import 'request_event.dart';
import 'request_state.dart';
import 'package:http/http.dart' as http;

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final RequestRepository requestRepository;

  RequestBloc({required this.requestRepository}) : super(RequestInitial()) {
    on<SubmitRequestEvent>(_onSubmitRequest);
    on<FetchRequests>(_onFetchRequests);
    on<ApproveRequestEvent>(_onApproveRequest);
    on<RejectRequestEvent>(_onRejectRequest);
    on<FetchTotalRequest>(_onFetchTotalRequest);
    on<MarkAsDoneEvent>(_onMarkAsDone); // Add the new event handler here
  }

  Future<void> _onSubmitRequest(
      SubmitRequestEvent event, Emitter<RequestState> emit) async {
    emit(RequestSubmitting());

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/database/request.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'venue_name': event.venue,
          'location': event.location,
          'full_name': event.fullName,
          'email': event.email,
          'mobile_number': event.mobileNumber,
          'request_date': event.date,
          'request_time': event.time,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          emit(RequestSubmitted(data['message']));
        } else {
          emit(RequestError(message: data['message'] ?? 'Unknown error'));
        }
      } else {
        emit(RequestError(message: 'Error: ${response.statusCode}'));
      }
    } catch (e) {
      emit(RequestError(message: e.toString()));
    }
  }

  Future<void> _onFetchRequests(FetchRequests event, Emitter<RequestState> emit) async {
    emit(RequestLoading());
    try {
      final requests = await requestRepository.fetchRequests();
      emit(RequestLoaded(requests));
    } catch (e) {
      emit(RequestError(message: e.toString()));
    }
  }

  Future<void> _onApproveRequest(ApproveRequestEvent event, Emitter<RequestState> emit) async {
    emit(RequestSubmitting());

    try {
      await requestRepository.approveRequest(event.id);
      emit(RequestApproved('Request approved successfully.'));
      final requests = await requestRepository.fetchRequests();
      emit(RequestLoaded(requests));
    } catch (e) {
      emit(RequestError(message: e.toString()));
    }
  }

  Future<void> _onRejectRequest(RejectRequestEvent event, Emitter<RequestState> emit) async {
    emit(RequestSubmitting());

    try {
      await requestRepository.rejectRequest(event.id);
      emit(RequestRejected('Request rejected successfully.'));
      final requests = await requestRepository.fetchRequests();
      emit(RequestLoaded(requests));
    } catch (e) {
      emit(RequestError(message: e.toString()));
    }
  }

  Future<void> _onFetchTotalRequest(FetchTotalRequest event, Emitter<RequestState> emit) async {
    emit(RequestLoading());
    try {
      final totalVenues = await requestRepository.fetchTotalRequest();
      emit(RequestTotalLoaded(totalVenues));
    } catch (e) {
      emit(RequestError(message: e.toString()));
    }
  }

  // New method to handle marking a request as done
  Future<void> _onMarkAsDone(MarkAsDoneEvent event, Emitter<RequestState> emit) async {
    emit(RequestSubmitting());

    try {
      await requestRepository.markAsDone(event.id); // Call the repository method
      emit(RequestApproved('Request marked as done successfully.'));
      final requests = await requestRepository.fetchRequests(); // Fetch updated requests
      emit(RequestLoaded(requests));
    } catch (e) {
      emit(RequestError(message: e.toString()));
    }
  }
}
