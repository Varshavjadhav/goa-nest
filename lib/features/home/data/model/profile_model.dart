class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profileImage;
  final String bio;
  final String role;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final String language;
  final String currency;

  const ProfileModel({
    this.id = '',
    this.name = '',
    this.email = '',
    this.phone = '',
    this.profileImage = '',
    this.bio = '',
    this.role = 'user',
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.language = 'en',
    this.currency = 'USD',
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: (json['_id'] ?? json['id'] ?? '').toString(),
    name: (json['name'] ?? json['fullName'] ?? '').toString(),
    email: (json['email'] ?? '').toString(),
    phone: (json['phone'] ?? json['phoneNumber'] ?? '').toString(),
    profileImage: (json['profileImage'] ??
            json['profilePhoto'] ??
            json['profilePicture'] ??
            json['avatar'] ??
            json['photo'] ??
            json['picture'] ??
            json['imageUrl'] ??
            '')
        .toString(),
    bio: (json['bio'] ?? '').toString(),
    role: (json['role'] ?? 'user').toString(),
    isEmailVerified: json['isEmailVerified'] == true,
    isPhoneVerified: json['isPhoneVerified'] == true,
    language: (json['language'] ?? 'en').toString(),
    currency: (json['currency'] ?? 'USD').toString(),
  );

  factory ProfileModel.fromResponseJson(Map<String, dynamic> json) {
    final user = json['user'];
    return ProfileModel.fromJson(
      user is Map ? Map<String, dynamic>.from(user) : json,
    );
  }

  ProfileModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? profileImage,
  }) => ProfileModel(
    id: id,
    name: name ?? this.name,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    profileImage: profileImage ?? this.profileImage,
    bio: bio ?? this.bio,
    role: role,
    isEmailVerified: isEmailVerified,
    isPhoneVerified: isPhoneVerified,
    language: language,
    currency: currency,
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'profileImage': profileImage,
    'bio': bio,
    'role': role,
    'isEmailVerified': isEmailVerified,
    'isPhoneVerified': isPhoneVerified,
    'language': language,
    'currency': currency,
  };

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((item) => item.isNotEmpty);
    final values = parts.toList();
    if (values.isEmpty) return '?';
    if (values.length == 1) return values.first.substring(0, 1).toUpperCase();
    return '${values.first[0]}${values.last[0]}'.toUpperCase();
  }
}

class ProfileUpdateRequest {
  final String name;
  final String phone;
  final String bio;

  const ProfileUpdateRequest({
    required this.name,
    required this.phone,
    required this.bio,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'bio': bio,
  };
}
