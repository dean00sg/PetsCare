import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/event/login_event.dart';
import 'package:frontend/users/repositories/login_repository.dart';
import 'package:frontend/users/state/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;

  LoginBloc({required this.loginRepository}) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
        emit(LoginLoading());
        try {
          final token = await loginRepository.login(event.loginData);
          print("Login successful, token: $token"); // Debugging statement
          emit(LoginSuccess(token: token));
        } catch (error) {
          print("Login failed: $error"); // Debugging statement
          emit(LoginFailure(error: error.toString()));
        }
      });

  }
  
}
