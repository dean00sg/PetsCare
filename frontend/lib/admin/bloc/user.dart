import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/event/user.dart';
import 'package:frontend/admin/repositories/user_repository.dart';
import 'package:frontend/admin/state/user.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    //Register the LoadUserPets event handler
    on<LoadUserPets>(_onLoadUserPets);
  }

  void _onLoadUserPets(
      LoadUserPets event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final profiles = await userRepository.getProfile();
      emit(UserPetsLoaded(profiles: profiles));
    } catch (_) {
      emit(UserLoadFailure());
    }
  }

  void loadUserPets() {
    add(LoadUserPets()); 
  }
}
