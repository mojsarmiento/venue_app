// request_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:venue_app/repository/request_repository.dart';
import 'dart:convert';
import 'request_event.dart';
import 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final RequestRepository requestRepository;
  
  RequestBloc({required this.requestRepository}) : super(RequestInitial()) {
    on<SubmitRequestEvent>(_onSubmitRequest);
    on<FetchRequests>(_onFetchRequests); 
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
          emit(RequestError(data['message']));
        }
      } else {
        emit(RequestError('Failed to submit request. Status code: ${response.statusCode}'));
      }
    } catch (e) {
      emit(RequestError('Error: ${e.toString()}'));
    }
  }

  Future<void> _onFetchRequests(FetchRequests event, Emitter<RequestState> emit) async {
    emit(RequestLoading());
    try {
      final requests = await requestRepository.fetchRequests();
      emit(RequestLoaded(requests));
    } catch (e) {
      emit(RequestError('Failed to fetch requests: ${e.toString()}'));
    }
  }
}





