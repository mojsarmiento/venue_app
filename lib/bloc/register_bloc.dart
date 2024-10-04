import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'register_event.dart';
import 'register_state.dart';
import 'package:logger/logger.dart'; // Import the logger package

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final Logger logger = Logger(); // Create a logger instance

  RegisterBloc() : super(RegisterInitial()) {
    on<SubmitRegistration>(_onSubmitRegistration);
  }

  Future<void> _onSubmitRegistration(SubmitRegistration event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/database/register_user.php'), // Update the URL as needed
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'full_name': event.fullName,
          'email': event.email,
          'password': event.password,
        }),
      );

      logger.d('Response status: ${response.statusCode}'); // Log the response status
      logger.d('Response body: ${response.body}'); // Log the raw response body

      // Check the response status code
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['error']) {
          emit(RegisterFailure(error: responseData['message']));
        } else {
          emit(RegisterSuccess(message: responseData['message']));
        }
      } else {
        emit(RegisterFailure(error: "Failed to register: ${response.reasonPhrase}"));
      }
    } catch (e) {
      logger.e('Error: $e'); // Log any errors
      emit(RegisterFailure(error: "Registration failed: ${e.toString()}"));
    }
  }
}
