import 'package:bloc/bloc.dart';
import 'package:frontend/users/models/profile_model.dart';
import 'package:frontend/users/repositories/profile_repository.dart';
import 'package:frontend/users/state/profile_state.dart';

class ProfileBloc extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final profile = await profileRepository.getProfile();
      emit(ProfileLoaded(profile));
    } catch (error) {
      emit(ProfileLoadFailure());
    }
  }

  Future<void> updateProfile(UserProfile updatedProfile) async {
    emit(ProfileUpdating());
    try {
      await profileRepository.updateProfile(updatedProfile);
      emit(ProfileUpdated(updatedProfile));
    } catch (error) {
      emit(ProfileUpdateFailure());
    }
  }
}