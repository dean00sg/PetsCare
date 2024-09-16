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
        final result = await loginRepository.login(event.loginData);
        
        // Handle the nullable string issue
        final token = result['access_token'] ?? ''; // Provide default value if null
        final role = result['role'] ?? ''; // Provide default value if null

        print("Login successful, token: $token, role: $role");
        emit(LoginSuccess(token: token, role: role));
      } catch (error) {
        print("Login failed: $error");
        emit(LoginFailure(error: error.toString()));
      }
    });
  }
}
