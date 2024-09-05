import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial());

  @override
  // ignore: override_on_non_overriding_member
  Stream<SignupState> mapEventToState(SignupEvent event) async* {
    if (event is SignupButtonPressed) {
      yield SignupLoading();
      try {
        // ดำเนินการสมัครสมาชิก (mock)
        await Future.delayed(const Duration(seconds: 2)); // จำลองการสมัคร
        yield SignupSuccess();
      } catch (error) {
        // ignore: prefer_const_constructors
        yield SignupFailure('Signup failed');
      }
    }
  }
}
