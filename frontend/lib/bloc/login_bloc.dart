import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  @override
  // ignore: override_on_non_overriding_member
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try {
        // Mock login authentication
        await Future.delayed(const Duration(seconds: 2));
        if (event.username == 'user' && event.password == 'password') {
          yield LoginSuccess();
        } else {
          yield const LoginFailure('Invalid credentials');
        }
      } catch (e) {
        yield const LoginFailure('Login failed');
      }
    }
  }
}
