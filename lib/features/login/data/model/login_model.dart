class LoginResponse {
  final Map<String, dynamic> user;
  final String accessToken;
  final String refreshToken;
  final String phone;

  const LoginResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.phone,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final user = Map<String, dynamic>.from(json['user'] as Map? ?? const {});
    final phone = (user['phone'] ??
            user['phoneNumber'] ??
            json['phone'] ??
            json['phoneNumber'] ??
            '')
        .toString();
    if (phone.isNotEmpty) user['phone'] = phone;
    return LoginResponse(
      user: user,
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
      phone: phone,
    );
  }
}
