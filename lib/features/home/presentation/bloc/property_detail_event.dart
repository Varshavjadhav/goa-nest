abstract class PropertyDetailEvent {}

class LoadPropertyDetail extends PropertyDetailEvent {
  final String propertyId;
  final String? checkIn;
  final String? checkOut;
  LoadPropertyDetail(this.propertyId, {this.checkIn, this.checkOut});
}
