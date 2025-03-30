class User {
  final String id;
  final String name;
  final String email;
  final String? token;
  final String? refreshToken;
  User({
    required this.id,
    required this.name,
    required this.email,
    this.token,
    this.refreshToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id']?.toString() ?? '0',
      name: json['name'] ?? 'User',
      email: json['email'] ?? '',
      token: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }
}
