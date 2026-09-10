abstract class PropertyDetailEvent {}

class LoadPropertyDetail extends PropertyDetailEvent {
  final String propertyId;
  LoadPropertyDetail(this.propertyId);
}
