import '../../data/model/profile_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileModel profile;
  final String? message;
  ProfileLoaded(this.profile, {this.message});
}

class ProfileUpdating extends ProfileState {
  final ProfileModel profile;
  ProfileUpdating(this.profile);
}

class ProfileError extends ProfileState {
  final String message;
  final ProfileModel? profile;
  ProfileError(this.message, {this.profile});
}
