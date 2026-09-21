class AvailabilityRequest {
  final String propertyId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final int rooms;

  const AvailabilityRequest({
    required this.propertyId,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    this.rooms = 1,
  });

  Map<String, dynamic> toJson() => {
    'propertyId': propertyId,
    'checkIn': _date(checkIn),
    'checkOut': _date(checkOut),
    'guests': guests,
    'rooms': rooms,
  };

  static String _date(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}

class BookingCollection {
  final List<BookingModel> bookings;
  final int total;
  final int page;
  final int pages;

  const BookingCollection({
    this.bookings = const [],
    this.total = 0,
    this.page = 1,
    this.pages = 0,
  });

  factory BookingCollection.fromJson(Map<String, dynamic> json) {
    final raw = json['bookings'];
    return BookingCollection(
      bookings: raw is List
          ? raw
                .whereType<Map>()
                .map(
                  (item) =>
                      BookingModel.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList()
          : const [],
      total: _bookingInt(json['total']),
      page: _bookingInt(json['page'], fallback: 1),
      pages: _bookingInt(json['pages']),
    );
  }
}

class BookingModel {
  final String id;
  final String propertyId;
  final String propertyTitle;
  final String propertyImage;
  final String propertyLocation;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final String status;
  final int adults;
  final int children;
  final int infants;
  final int nights;
  final double pricePerNight;
  final double totalPrice;
  final double cleaningFee;
  final double serviceFee;

  const BookingModel({
    this.id = '',
    this.propertyId = '',
    this.propertyTitle = '',
    this.propertyImage = '',
    this.propertyLocation = '',
    this.checkIn,
    this.checkOut,
    this.status = 'pending',
    this.adults = 1,
    this.children = 0,
    this.infants = 0,
    this.nights = 0,
    this.pricePerNight = 0,
    this.totalPrice = 0,
    this.cleaningFee = 0,
    this.serviceFee = 0,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final property = json['property'] is Map
        ? Map<String, dynamic>.from(json['property'])
        : <String, dynamic>{};
    final location = property['location'] is Map
        ? Map<String, dynamic>.from(property['location'])
        : <String, dynamic>{};
    final guests = json['guests'] is Map
        ? Map<String, dynamic>.from(json['guests'])
        : <String, dynamic>{};
    final images = property['images'] is List
        ? property['images'] as List
        : const [];
    final firstImage = images.isEmpty
        ? ''
        : images.first is Map
        ? (images.first as Map)['url']?.toString() ?? ''
        : images.first.toString();
    return BookingModel(
      id: _bookingString(json['_id'] ?? json['id']),
      propertyId: _bookingString(
        property['_id'] ?? property['id'] ?? json['property'],
      ),
      propertyTitle: _bookingString(property['title']),
      propertyImage: firstImage,
      propertyLocation: [location['city'], location['country']]
          .where((value) => value != null && value.toString().isNotEmpty)
          .join(', '),
      checkIn: DateTime.tryParse(_bookingString(json['checkIn'])),
      checkOut: DateTime.tryParse(_bookingString(json['checkOut'])),
      status: _bookingString(json['status'], fallback: 'pending'),
      adults: _bookingInt(guests['adults'], fallback: 1),
      children: _bookingInt(guests['children']),
      infants: _bookingInt(guests['infants']),
      nights: _bookingInt(json['nights']),
      pricePerNight: _bookingNumber(json['pricePerNight']),
      totalPrice: _bookingNumber(json['totalPrice']),
      cleaningFee: _bookingNumber(json['cleaningFee']),
      serviceFee: _bookingNumber(json['serviceFee']),
    );
  }

  factory BookingModel.fromResponseJson(Map<String, dynamic> json) =>
      BookingModel.fromJson(
        json['booking'] is Map
            ? Map<String, dynamic>.from(json['booking'])
            : json,
      );
}

class CreateBookingRequest {
  final String propertyId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int adults;
  final int children;
  final int infants;
  final String specialRequests;

  const CreateBookingRequest({
    required this.propertyId,
    required this.checkIn,
    required this.checkOut,
    this.adults = 1,
    this.children = 0,
    this.infants = 0,
    this.specialRequests = '',
  });

  Map<String, dynamic> toJson() => {
    'property': propertyId,
    'checkIn': _bookingDate(checkIn),
    'checkOut': _bookingDate(checkOut),
    'guests': {'adults': adults, 'children': children, 'infants': infants},
    if (specialRequests.isNotEmpty) 'specialRequests': specialRequests,
  };
}

String _bookingString(dynamic value, {String fallback = ''}) =>
    value == null ? fallback : value.toString();
int _bookingInt(dynamic value, {int fallback = 0}) => value is num
    ? value.toInt()
    : int.tryParse(_bookingString(value)) ?? fallback;
double _bookingNumber(dynamic value) => value is num
    ? value.toDouble()
    : double.tryParse(_bookingString(value)) ?? 0;
String _bookingDate(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';

class AvailabilityResult {
  final bool available;
  final String bookingType;
  final double nightlyAmount;
  final double cleaningFee;
  final double serviceFee;
  final double tax;
  final double discount;
  final double totalAmount;
  final String message;

  const AvailabilityResult({
    this.available = false,
    this.bookingType = 'instant',
    this.nightlyAmount = 0,
    this.cleaningFee = 0,
    this.serviceFee = 0,
    this.tax = 0,
    this.discount = 0,
    this.totalAmount = 0,
    this.message = '',
  });

  factory AvailabilityResult.fromJson(Map<String, dynamic> json) {
    final price = json['price'] is Map
        ? Map<String, dynamic>.from(json['price'])
        : json;
    return AvailabilityResult(
      available: json['available'] == true,
      bookingType: (json['bookingType'] ?? 'instant').toString(),
      nightlyAmount: _number(price['nightlyAmount'] ?? price['nightlyPrice']),
      cleaningFee: _number(price['cleaningFee']),
      serviceFee: _number(price['serviceFee']),
      tax: _number(price['tax']),
      discount: _number(price['discount']),
      totalAmount: _number(price['totalAmount'] ?? price['total']),
      message: (json['message'] ?? '').toString(),
    );
  }

  static double _number(dynamic value) => value is num
      ? value.toDouble()
      : double.tryParse(value?.toString() ?? '') ?? 0;
}
