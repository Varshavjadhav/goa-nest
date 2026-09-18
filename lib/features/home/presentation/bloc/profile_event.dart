import '../../data/model/profile_model.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final ProfileUpdateRequest request;
  UpdateProfile(this.request);
}
