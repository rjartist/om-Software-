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
        listOfFacilities!.add(new ListOfFacilities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.listOfFacilities != null) {
      data['listOfFacilities'] =
          this.listOfFacilities!.map((v) => v.toJson()).toList();
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
  Feedback? feedback;

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
        facilityImages!.add(new FacilityImages.fromJson(v));
      });
    }
    if (json['favorites'] != null) {
      favorites = <Favorites>[];
      json['favorites'].forEach((v) {
        favorites!.add(new Favorites.fromJson(v));
      });
    }
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }
    feedback =
        json['feedback'] != null
            ? new Feedback.fromJson(json['feedback'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facility_id'] = this.facilityId;
    data['facility_name'] = this.facilityName;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zipcode'] = this.zipcode;
    data['other'] = this.other;
    data['google_map_url'] = this.googleMapUrl;
    if (this.facilityImages != null) {
      data['facility_images'] =
          this.facilityImages!.map((v) => v.toJson()).toList();
    }
    if (this.favorites != null) {
      data['favorites'] = this.favorites!.map((v) => v.toJson()).toList();
    }
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    if (this.feedback != null) {
      data['feedback'] = this.feedback!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facility_image_id'] = this.facilityImageId;
    data['image'] = this.image;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_favorite'] = this.isFavorite;
    return data;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
    data['min_rate'] = this.minRate;
    return data;
  }
}

class Feedback {
  int? totalCount;
  dynamic averageRating;

  Feedback({this.totalCount, this.averageRating});

  Feedback.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    averageRating = json['averageRating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    data['averageRating'] = this.averageRating;
    return data;
  }
}
