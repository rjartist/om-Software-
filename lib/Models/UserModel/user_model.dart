import 'dart:convert';

class UserModel {
  final int userId;
  final String userEmail;
  final String accessToken;

  UserModel({
    required this.userId,
    required this.userEmail,
    required this.accessToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] ?? 0,
      userEmail: json['user_email'] ?? '',
      accessToken: json['accessToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'user_email': userEmail,
        'accessToken': accessToken,
      };

  String toJsonString() => jsonEncode(toJson());

  static UserModel? fromJsonString(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return null;
    return UserModel.fromJson(jsonDecode(jsonString));
  }
}
