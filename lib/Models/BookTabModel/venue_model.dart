class VenueModel {
  final int facilityId;
  final String venueName; // facility_name
  final String venueAddress; // address
  final String imageUrl;
  final String city;
  final String state;
  final String zipcode;
  final String googleMapUrl;
  final String facilityStartHour;
  final String facilityEndHour;
  final List<String> facilityImages; // image list
  final double rating; // feedback.averageRating
  final int totalReviews; // feedback.totalCount
  final int price; // For dummy data only, default = 0 if missing in API

  VenueModel({
    required this.facilityId,
    required this.venueName,
    required this.venueAddress,
    required this.imageUrl,
    required this.city,
    required this.state,
    required this.zipcode,
    required this.googleMapUrl,
    required this.facilityStartHour,
    required this.facilityEndHour,
    required this.facilityImages,
    required this.rating,
    required this.totalReviews,
    required this.price,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? facilityImagesList =
        json['facility_images'] as List<dynamic>?;
    final String fallbackImage =
        facilityImagesList != null && facilityImagesList.isNotEmpty
            ? facilityImagesList.first['image'] ?? ''
            : '';

    final List<dynamic>? servicesList = json['services'] as List<dynamic>?;
    final int minRate =
        servicesList != null && servicesList.isNotEmpty
            ? (servicesList.first['min_rate'] ?? 0)
            : 0;

    return VenueModel(
      facilityId: json['facility_id'] ?? 0,
      venueName: json['facility_name'] ?? '',
      venueAddress: json['address'] ?? '',
      imageUrl: fallbackImage,
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipcode: json['zipcode'] ?? '',
      googleMapUrl: json['google_map_url'] ?? '',
      facilityStartHour: json['facility_start_hour'] ?? '',
      facilityEndHour: json['facility_end_hour'] ?? '',
      facilityImages:
          facilityImagesList?.map((e) => e['image'] as String).toList() ?? [],
      rating: (json['feedback']?['averageRating'] ?? 0).toDouble(),
      totalReviews: json['feedback']?['totalCount'] ?? 0,
      price: minRate,
    );
  }

  /// For dummy data conversion
  factory VenueModel.fromDummyJson(Map<String, dynamic> json) {
    return VenueModel(
      facilityId: 0,
      venueName: json['venueName'] ?? '',
      venueAddress: json['venueAddress'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      city: '',
      state: '',
      zipcode: '',
      googleMapUrl: '',
      facilityStartHour: '',
      facilityEndHour: '',
      facilityImages: [json['imageUrl'] ?? ''],
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      price: json['price'] ?? 0,
    );
  }
}
