class MyFavoritesModel {
  bool? success;
  String? message;
  List<ListOfFacilities>? listOfFacilities;

  MyFavoritesModel({this.success, this.message, this.listOfFacilities});

  MyFavoritesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['listOfFacilities'] != null) {
      listOfFacilities = <ListOfFacilities>[];
      json['listOfFacilities'].forEach((v) {
        listOfFacilities!.add(ListOfFacilities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (listOfFacilities != null) {
      data['listOfFacilities'] =
          listOfFacilities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListOfFacilities {
  int? facilityId;
  String? facilityName;
  String? address;
  String? city;
  String? state;
  String? zipcode;
  String? other;
  String? googleMapUrl;
  List<FacilityImages>? facilityImages;
  List<Favorites>? favorites;
  List<Services>? services;
  FacilityFeedback? feedback; // ✅ renamed

  ListOfFacilities({
    this.facilityId,
    this.facilityName,
    this.address,
    this.city,
    this.state,
    this.zipcode,
    this.other,
    this.googleMapUrl,
    this.facilityImages,
    this.favorites,
    this.services,
    this.feedback,
  });

  ListOfFacilities.fromJson(Map<String, dynamic> json) {
    facilityId = json['facility_id'];
    facilityName = json['facility_name'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zipcode = json['zipcode'];
    other = json['other'];
    googleMapUrl = json['google_map_url'];

    if (json['facility_images'] != null) {
      facilityImages = <FacilityImages>[];
      json['facility_images'].forEach((v) {
        facilityImages!.add(FacilityImages.fromJson(v));
      });
    }

    if (json['favorites'] != null) {
      favorites = <Favorites>[];
      json['favorites'].forEach((v) {
        favorites!.add(Favorites.fromJson(v));
      });
    }

    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }

    feedback =
        json['feedback'] != null ? FacilityFeedback.fromJson(json['feedback']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['facility_id'] = facilityId;
    data['facility_name'] = facilityName;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['zipcode'] = zipcode;
    data['other'] = other;
    data['google_map_url'] = googleMapUrl;

    if (facilityImages != null) {
      data['facility_images'] = facilityImages!.map((v) => v.toJson()).toList();
    }
    if (favorites != null) {
      data['favorites'] = favorites!.map((v) => v.toJson()).toList();
    }
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    if (feedback != null) {
      data['feedback'] = feedback!.toJson();
    }
    return data;
  }
}

class FacilityImages {
  int? facilityImageId;
  String? image;

  FacilityImages({this.facilityImageId, this.image});

  FacilityImages.fromJson(Map<String, dynamic> json) {
    facilityImageId = json['facility_image_id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['facility_image_id'] = facilityImageId;
    data['image'] = image;
    return data;
  }
}

class Favorites {
  bool? isFavorite;

  Favorites({this.isFavorite});

  Favorites.fromJson(Map<String, dynamic> json) {
    isFavorite = json['is_favorite'];
  }

  Map<String, dynamic> toJson() {
    return {'is_favorite': isFavorite};
  }
}

class Services {
  int? serviceId;
  String? serviceName;
  int? minRate;

  Services({this.serviceId, this.serviceName, this.minRate});

  Services.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    minRate = json['min_rate'];
  }

  Map<String, dynamic> toJson() {
    return {
      'service_id': serviceId,
      'service_name': serviceName,
      'min_rate': minRate,
    };
  }
}

class FacilityFeedback {
  int? totalCount;
  dynamic averageRating;

  FacilityFeedback({this.totalCount, this.averageRating});

  FacilityFeedback.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    averageRating = json['averageRating'];
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalCount,
      'averageRating': averageRating,
    };
  }
}
