class RegisterResponse {
  final Map<String, dynamic> user;
  final String name;
  final String email;
  final String accessToken;
  final String refreshToken;

  const RegisterResponse({
    required this.user,
    required this.name,
    required this.email,
    required this.accessToken,
    required this.refreshToken,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    final user = Map<String, dynamic>.from(json['user'] as Map? ?? const {});
    return RegisterResponse(
      user: user,
      name: user['name']?.toString() ?? '',
      email: user['email']?.toString() ?? '',
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
    );
  }
}
