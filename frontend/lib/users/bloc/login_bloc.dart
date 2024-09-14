import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/users/event/login_event.dart';
import 'package:frontend/users/repositories/login_repository.dart';
import 'package:frontend/users/state/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;

  // Initialize LoginBloc with a LoginRepository instance
  LoginBloc({required this.loginRepository}) : super(LoginInitial()) {
    // Handle the LoginButtonPressed event
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading()); // Emit loading state before starting login process
      try {
        // Attempt to login using the provided login data
        final token = await loginRepository.login(event.loginData);
        // If successful, emit the success state with the token
        emit(LoginSuccess(token: token));
      } catch (error) {
        // If an error occurs, emit the failure state with the error message
        emit(LoginFailure(error: error.toString()));
      }
    });
  }
}