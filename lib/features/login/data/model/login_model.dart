class LoginResponse {
  final Map<String, dynamic> user;
  final String accessToken;
  final String refreshToken;

  const LoginResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: Map<String, dynamic>.from(json['user'] as Map? ?? const {}),
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
    );
  }
}
