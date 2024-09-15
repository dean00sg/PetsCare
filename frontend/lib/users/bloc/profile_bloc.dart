import 'package:bloc/bloc.dart';
import 'package:frontend/users/models/profile_model.dart';
import 'package:frontend/users/repositories/profile_repository.dart';

// Profile Bloc
class ProfileBloc extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading()); // Emit loading state before loading the profile
    try {
      final profile = await profileRepository.getProfile();
      emit(ProfileLoaded(profile)); // Emit the profile loaded state if successful
    } catch (error) {
      emit(ProfileLoadFailure()); // Emit failure state if there's an error
    }
  }
}

// States:
abstract class ProfileState {}

// Initial state when the ProfileBloc is created
class ProfileInitial extends ProfileState {}

// Loading state when profile data is being fetched
class ProfileLoading extends ProfileState {}

// State when the profile is successfully loaded
class ProfileLoaded extends ProfileState {
  final UserProfile profile;
  ProfileLoaded(this.profile);
}

// State when there's an error loading the profile
class ProfileLoadFailure extends ProfileState {}
