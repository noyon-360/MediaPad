class UserModel {
  final String name;
  final String email;
  final String token;

  UserModel({
    required this.name,
    required this.email,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    try {
      return UserModel(
        name: json['name'] as String,
        email: json['email'] as String,
        token: json['token'] as String,
      );
    } catch (e) {
      throw FormatException('Failed to parse UserModel: $e');
    }
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'token': token,
      };
}
