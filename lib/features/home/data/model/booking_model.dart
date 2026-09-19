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
