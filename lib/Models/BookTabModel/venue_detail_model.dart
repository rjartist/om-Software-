// Root model for Venue Detail
class VenueDetailModel {
  final bool isFavorite;
  final ModifiedFacility modifiedFacility;

  VenueDetailModel({required this.isFavorite, required this.modifiedFacility});

  factory VenueDetailModel.fromJson(Map<String, dynamic> json) {
    return VenueDetailModel(
      isFavorite: json['is_favorite'] ?? false,
      modifiedFacility: ModifiedFacility.fromJson(
        json['modifiedFacility'] ?? {},
      ),
    );
  }
}

// Modified Facility Details
class ModifiedFacility {
  final int facilityId;
  final String facilityName;
  final String address;
  final String city;
  final String state;
  final String zipcode;
  final String googleMapUrl;
  final String other;
  final String facilityStartHour;
  final String facilityEndHour;
  final List<FacilityImage> facilityImages;
  final List<FacilityAmenity> facilityAmenities;
  final List<Service> services;
  final FeedbackData feedback;

  ModifiedFacility({
    required this.facilityId,
    required this.facilityName,
    required this.address,
    required this.city,
    required this.state,
    required this.zipcode,
    required this.googleMapUrl,
    required this.other,
    required this.facilityStartHour,
    required this.facilityEndHour,
    required this.facilityImages,
    required this.facilityAmenities,
    required this.services,
    required this.feedback,
  });

  factory ModifiedFacility.fromJson(Map<String, dynamic> json) {
    return ModifiedFacility(
      facilityId: json['facility_id'] ?? 0,
      facilityName: json['facility_name']?.toString().trim() ?? '',
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      zipcode: json['zipcode']?.toString() ?? '',
      googleMapUrl: json['google_map_url']?.toString() ?? '',
      other: json['other']?.toString() ?? '',
      facilityStartHour: json['facility_start_hour']?.toString() ?? '',
      facilityEndHour: json['facility_end_hour']?.toString() ?? '',
      facilityImages:
          (json['facility_images'] as List<dynamic>?)
              ?.map((e) => FacilityImage.fromJson(e))
              .toList() ??
          [],
      facilityAmenities:
          (json['facility_amenities'] as List<dynamic>?)
              ?.map((e) => FacilityAmenity.fromJson(e))
              .toList() ??
          [],
      services:
          (json['services'] as List<dynamic>?)
              ?.map((e) => Service.fromJson(e))
              .toList() ??
          [],
      feedback: FeedbackData.fromJson(json['feedback'] ?? {}),
    );
  }
}

// Facility Image
class FacilityImage {
  final int facilityImageId;
  final String image;

  FacilityImage({required this.facilityImageId, required this.image});

  factory FacilityImage.fromJson(Map<String, dynamic> json) {
    return FacilityImage(
      facilityImageId: json['facility_image_id'] ?? 0,
      image: json['image']?.toString() ?? '',
    );
  }
}

// Facility Amenity
class FacilityAmenity {
  final int facilityAmenitiesId;
  final String amenityName;
  final String other;

  FacilityAmenity({
    required this.facilityAmenitiesId,
    required this.amenityName,
    required this.other,
  });

  factory FacilityAmenity.fromJson(Map<String, dynamic> json) {
    return FacilityAmenity(
      facilityAmenitiesId: json['facility_amenities_id'] ?? 0,
      amenityName: json['amenity_name']?.toString() ?? '',
      other: json['other']?.toString() ?? '',
    );
  }
}

// Service Model
class Service {
  final int serviceId;
  final String serviceName;
  final double minHour;
  final List<ServiceImage> serviceImages;
  final List<Unit> units;

  Service({
    required this.serviceId,
    required this.serviceName,
    required this.minHour,
    required this.serviceImages,
    required this.units,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceId: json['service_id'] ?? 0,
      serviceName: json['service_name']?.toString() ?? '',
      minHour:
          (json['min_hour'] is num)
              ? (json['min_hour'] as num).toDouble()
              : 0.0,

      serviceImages:
          (json['service_images'] as List<dynamic>?)
              ?.map((e) => ServiceImage.fromJson(e))
              .toList() ??
          [],
      units:
          (json['units'] as List<dynamic>?)
              ?.map((e) => Unit.fromJson(e))
              .toList() ??
          [],
    );
  }
}

// Service Image
class ServiceImage {
  final int serviceImageId;
  final String image;

  ServiceImage({required this.serviceImageId, required this.image});

  factory ServiceImage.fromJson(Map<String, dynamic> json) {
    return ServiceImage(
      serviceImageId: json['service_image_id'] ?? 0,
      image: json['image']?.toString() ?? '',
    );
  }
}

// Unit Model
class Unit {
  final int unitId;
  final String unitName;

  Unit({required this.unitId, required this.unitName});

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      unitId: json['unit_id'] ?? 0,
      unitName: json['unit_name']?.toString() ?? '',
    );
  }
}

// Feedback Data
class FeedbackData {
  final int totalCount;
  final double averageRating;

  FeedbackData({required this.totalCount, required this.averageRating});

  factory FeedbackData.fromJson(Map<String, dynamic> json) {
    return FeedbackData(
      totalCount: json['totalCount'] ?? 0,
      averageRating: (json['averageRating'] ?? 0).toDouble(),
    );
  }
}
