class VenueModel {
  final String venueName;
  final String venueAddress;
  final String imageUrl;
  final double rating;
  final int totalReviews;
  final int price;

  VenueModel({
    required this.venueName,
    required this.venueAddress,
    required this.imageUrl,
    required this.rating,
    required this.totalReviews,
    required this.price,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      venueName: json['venueName'] ?? '',
      venueAddress: json['venueAddress'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      price: json['price'] ?? 0,
    );
  }
}
