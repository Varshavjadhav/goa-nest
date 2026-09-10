import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repository/home_repository.dart';
import 'property_detail_event.dart';
import 'property_detail_state.dart';

class PropertyDetailBloc
    extends Bloc<PropertyDetailEvent, PropertyDetailState> {
  final HomeRepository repository;

  PropertyDetailBloc(this.repository) : super(PropertyDetailInitial()) {
    on<LoadPropertyDetail>((event, emit) async {
      if (event.propertyId.trim().isEmpty) {
        emit(PropertyDetailError('Property ID is missing.'));
        return;
      }
      emit(PropertyDetailLoading());
      final result = await repository.getProperty(event.propertyId);
      result.fold((error) => emit(PropertyDetailError(error.message)), (
        property,
      ) async {
        emit(PropertyDetailLoaded(property));
        await repository.markRecentlyViewed(event.propertyId);
      });
    });
  }
}
