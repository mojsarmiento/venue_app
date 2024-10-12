// update_state.dart

abstract class UpdateState {}

class UpdateInitial extends UpdateState {}

class UpdateLoading extends UpdateState {}

class UpdateSuccess extends UpdateState {}

class UpdateError extends UpdateState {
  final String message;

  UpdateError(this.message);
}
