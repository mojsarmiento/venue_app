import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venue_app/services/api_service.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ApiService apiService;

  LoginBloc({required this.apiService}) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      try {
        final response = await apiService.login(event.email, event.password);
        if (response.isSuccess) {
          emit(LoginSuccess(email: event.email, userType: response.userType));
        } else {
          emit(LoginFailure(error: response.message ?? 'Login failed'));
        }
      } catch (error) {
        emit(LoginFailure(error: error.toString()));
      }
    });
  }
}