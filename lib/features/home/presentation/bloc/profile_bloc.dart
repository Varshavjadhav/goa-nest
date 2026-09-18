import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/profile_model.dart';
import '../../domain/usecase/profile_usecases.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfile;
  final UpdateProfileUseCase updateProfile;

  ProfileBloc(this.getProfile, this.updateProfile) : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      final result = await getProfile();
      result.fold((error) => emit(ProfileError(error.message)), (profile) => emit(ProfileLoaded(profile)));
    });
    on<UpdateProfile>((event, emit) async {
      final current = _currentProfile;
      if (current != null) emit(ProfileUpdating(current));
      final result = await updateProfile(event.request);
      result.fold(
        (error) => emit(ProfileError(error.message, profile: current)),
        (profile) => emit(ProfileLoaded(profile, message: 'Profile updated successfully')),
      );
    });
  }

  ProfileModel? get _currentProfile => switch (state) {
    ProfileLoaded value => value.profile,
    ProfileUpdating value => value.profile,
    ProfileError value => value.profile,
    _ => null,
  };
}
