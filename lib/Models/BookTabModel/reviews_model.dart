
class VenueReviewsResponseModel {
  final double averageRating;
  final int totalReviews;
  final List<ReviewModel> reviews;

  VenueReviewsResponseModel({
    required this.averageRating,
    required this.totalReviews,
    required this.reviews,
  });

  factory VenueReviewsResponseModel.fromJson(Map<String, dynamic> json) {
    return VenueReviewsResponseModel(
      averageRating: double.tryParse(json['averageRating']?.toString() ?? "0.0") ?? 0.0,
      totalReviews: json['totalReviews'] ?? 0,
      reviews: (json['formattedFeedbacks'] as List<dynamic>?)
              ?.map((e) => ReviewModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}


class ReviewModel {
  final int feedbackId;
  final int venueId;
  final int rating;
  final String? feedback;
  final String createdAt;
  final UserModel user;

  ReviewModel({
    required this.feedbackId,
    required this.venueId,
    required this.rating,
    required this.feedback,
    required this.createdAt,
    required this.user,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      feedbackId: json['feedback_id'] ?? 0,
      venueId: json['venue_id'] ?? 0,
      rating: json['rating'] ?? 0,
      feedback: json['feedback'],
      createdAt: json['created_at'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
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
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? '',
      profileImage: json['profile_image'] ?? '',
    );
  }
}
