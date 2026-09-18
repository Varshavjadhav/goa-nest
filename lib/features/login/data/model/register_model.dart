class RegisterResponse {
  final Map<String, dynamic> user;
  final String name;
  final String email;
  final String phone;
  final String accessToken;
  final String refreshToken;

  const RegisterResponse({
    required this.user,
    required this.name,
    required this.email,
    required this.phone,
    required this.accessToken,
    required this.refreshToken,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    final user = Map<String, dynamic>.from(json['user'] as Map? ?? const {});
    final phone = (user['phone'] ??
            user['phoneNumber'] ??
            json['phone'] ??
            json['phoneNumber'] ??
            '')
        .toString();
    if (phone.isNotEmpty) user['phone'] = phone;
    return RegisterResponse(
      user: user,
      name: user['name']?.toString() ?? '',
      email: user['email']?.toString() ?? '',
      phone: phone,
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
    );
  }
}
