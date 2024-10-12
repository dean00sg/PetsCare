import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/event/signup_event.dart';
import 'package:frontend/users/state/signup_state.dart';
import 'package:frontend/users/repositories/signup_repository.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupRepository signupRepository;

  SignupBloc({required this.signupRepository}) : super(SignupInitial()) {
    // ลงทะเบียน SignupButtonPressed
    on<SignupButtonPressed>((event, emit) async {
      emit(SignupLoading());
      try {
        // เรียกใช้ฟังก์ชันจาก repository เพื่อสมัครสมาชิก
        final user = await signupRepository.signup(event.signupData);
        emit(SignupSuccess(user: user));
      } catch (error) {
        emit(SignupFailure(error: error.toString()));
      }
    });
  }
}
