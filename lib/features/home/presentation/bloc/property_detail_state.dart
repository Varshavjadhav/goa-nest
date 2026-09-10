import '../../data/model/property_detail_model.dart';

abstract class PropertyDetailState {}

class PropertyDetailInitial extends PropertyDetailState {}

class PropertyDetailLoading extends PropertyDetailState {}

class PropertyDetailLoaded extends PropertyDetailState {
  final PropertyDetailModel property;
  PropertyDetailLoaded(this.property);
}

class PropertyDetailError extends PropertyDetailState {
  final String message;
  PropertyDetailError(this.message);
}
