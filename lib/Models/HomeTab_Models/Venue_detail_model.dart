class VenueDetailModel {
  final String venueId;
  final String venueName;
  final String venueAddress;
  final List<String> images;
  final double rating;
  final int totalReviews;
  final int price;
  final List<Sport> availableSports;
  final List<String> amenities;
  final int totalGamesPlayed;
  final int turfCount;

  VenueDetailModel({
    required this.venueId,
    required this.venueName,
    required this.venueAddress,
    required this.images,
    required this.rating,
    required this.totalReviews,
    required this.price,
    required this.availableSports,
    required this.amenities,
    required this.totalGamesPlayed,
    required this.turfCount,
  });

  factory VenueDetailModel.fromJson(Map<String, dynamic> json) {
    return VenueDetailModel(
      venueId: json['venueId'],
      venueName: json['venueName'],
      venueAddress: json['venueAddress'],
      images: List<String>.from(json['images']),
      rating: (json['rating'] as num).toDouble(),
      totalReviews: json['totalReviews'],
      price: json['price'],
      availableSports: (json['availableSports'] as List)
          .map((e) => Sport.fromJson(e))
          .toList(),
      amenities: List<String>.from(json['amenities']),
      totalGamesPlayed: json['totalGamesPlayed'],
      turfCount: json['turfCount'],
    );
  }
}

class Sport {
  final String sportName;
  final String image;

  Sport({required this.sportName, required this.image});

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      sportName: json['sportName'],
      image: json['image'],
    );
  }
}
