class ReviewModel {
  final int feedbackId;
  final int venueId;
  final String feedback;
  final UserModel user;

  ReviewModel({
    required this.feedbackId,
    required this.venueId,
    required this.feedback,
    required this.user,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      feedbackId: json['feedback_id'],
      venueId: json['venue_id'],
      feedback: json['feedback'],
      user: UserModel.fromJson(json['user']),
    );
  }
}

class UserModel {
  final int userId;
  final String name;
  final String profileImage;

  UserModel({
    required this.userId,
    required this.name,
    required this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      name: json['name'],
      profileImage: json['profile_image'],
    );
  }
}
