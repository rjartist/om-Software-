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
  final int price; // from services.min_rate
  final bool isFavorite; // from API
  final List<ServiceModel> services;
  final String other; // extra info (optional)

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
    this.isFavorite = false,
    this.services = const [],
    this.other = '',
  });


    VenueModel copyWith({
    int? facilityId,
    String? venueName,
    String? venueAddress,
    String? imageUrl,
    String? city,
    String? state,
    String? zipcode,
    String? googleMapUrl,
    String? facilityStartHour,
    String? facilityEndHour,
    List<String>? facilityImages,
    double? rating,
    int? totalReviews,
    int? price,
    bool? isFavorite,
    List<ServiceModel>? services,
    String? other,
  }) {
    return VenueModel(
      facilityId: facilityId ?? this.facilityId,
      venueName: venueName ?? this.venueName,
      venueAddress: venueAddress ?? this.venueAddress,
      imageUrl: imageUrl ?? this.imageUrl,
      city: city ?? this.city,
      state: state ?? this.state,
      zipcode: zipcode ?? this.zipcode,
      googleMapUrl: googleMapUrl ?? this.googleMapUrl,
      facilityStartHour: facilityStartHour ?? this.facilityStartHour,
      facilityEndHour: facilityEndHour ?? this.facilityEndHour,
      facilityImages: facilityImages ?? this.facilityImages,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      price: price ?? this.price,
      isFavorite: isFavorite ?? this.isFavorite,
      services: services ?? this.services,
      other: other ?? this.other,
    );
  }

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    final facilityImagesList = json['facility_images'] as List<dynamic>?;
    final String fallbackImage =
        facilityImagesList != null && facilityImagesList.isNotEmpty
            ? facilityImagesList.first['image'] ?? ''
            : '';

    final servicesList = (json['services'] as List<dynamic>?) ?? [];
    final int minRate =
        servicesList.isNotEmpty ? (servicesList.first['min_rate'] ?? 0) : 0;

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
      isFavorite: json['is_favorite'] ?? false,
      services: servicesList.map((e) => ServiceModel.fromJson(e)).toList(),
      other: json['other'] ?? '',
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

class ServiceModel {
  final int serviceId;
  final String serviceName;
  final int minRate;

  ServiceModel({
    required this.serviceId,
    required this.serviceName,
    required this.minRate,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      serviceId: json['service_id'] ?? 0,
      serviceName: json['service_name'] ?? '',
      minRate: json['min_rate'] ?? 0,
    );
  }
}
