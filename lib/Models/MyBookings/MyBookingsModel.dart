class MyBookingsModel {
  bool? success;
  String? message;
  List<PastBookings>? pastBookings;
  List<FutureBookings>? futureBookings;
  List<CancelledBookings>? cancelledBookings;

  MyBookingsModel({
    this.success,
    this.message,
    this.pastBookings,
    this.futureBookings,
    this.cancelledBookings,
  });

  MyBookingsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['pastBookings'] != null) {
      pastBookings = <PastBookings>[];
      json['pastBookings'].forEach((v) {
        pastBookings!.add(new PastBookings.fromJson(v));
      });
    }
    if (json['futureBookings'] != null) {
      futureBookings = <FutureBookings>[];
      json['futureBookings'].forEach((v) {
        futureBookings!.add(new FutureBookings.fromJson(v));
      });
    }
    if (json['cancelledBookings'] != null) {
      cancelledBookings = <CancelledBookings>[];
      json['cancelledBookings'].forEach((v) {
        cancelledBookings!.add(new CancelledBookings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.pastBookings != null) {
      data['pastBookings'] = this.pastBookings!.map((v) => v.toJson()).toList();
    }
    if (this.futureBookings != null) {
      data['futureBookings'] =
          this.futureBookings!.map((v) => v.toJson()).toList();
    }
    if (this.cancelledBookings != null) {
      data['cancelledBookings'] =
          this.cancelledBookings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PastBookings {
  int? bookingId;
  String? startDate;
  String? endDate;
  int? userOrOwnerId;
  List<FacilityBookingSlots>? facilityBookingSlots;
  Payment? payment;
  BookingCancellationRequest? bookingCancellationRequest;
  String? cancellationStatus;

  PastBookings({
    this.bookingId,
    this.startDate,
    this.endDate,
    this.userOrOwnerId,
    this.facilityBookingSlots,
    this.payment,
    this.bookingCancellationRequest,
    this.cancellationStatus,
  });

  PastBookings.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    userOrOwnerId = json['user_or_owner_id'];
    if (json['facility_booking_slots'] != null) {
      facilityBookingSlots = <FacilityBookingSlots>[];
      json['facility_booking_slots'].forEach((v) {
        facilityBookingSlots!.add(new FacilityBookingSlots.fromJson(v));
      });
    }
    payment =
        json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
    bookingCancellationRequest =
        json['booking_cancellation_request'] != null
            ? new BookingCancellationRequest.fromJson(
              json['booking_cancellation_request'],
            )
            : null;
    cancellationStatus = json['cancellation_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['user_or_owner_id'] = this.userOrOwnerId;
    if (this.facilityBookingSlots != null) {
      data['facility_booking_slots'] =
          this.facilityBookingSlots!.map((v) => v.toJson()).toList();
    }
    if (this.payment != null) {
      data['payment'] = this.payment!.toJson();
    }
    if (this.bookingCancellationRequest != null) {
      data['booking_cancellation_request'] =
          this.bookingCancellationRequest!.toJson();
    }
    data['cancellation_status'] = this.cancellationStatus;
    return data;
  }
}

class FutureBookings {
  int? bookingId;
  String? startDate;
  String? endDate;
  int? userOrOwnerId;
  List<FacilityBookingSlots>? facilityBookingSlots;
  Payment? payment;
  BookingCancellationRequest? bookingCancellationRequest;
  String? cancellationStatus;

  FutureBookings({
    this.bookingId,
    this.startDate,
    this.endDate,
    this.userOrOwnerId,
    this.facilityBookingSlots,
    this.payment,
    this.bookingCancellationRequest,
    this.cancellationStatus,
  });

  FutureBookings.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    userOrOwnerId = json['user_or_owner_id'];
    if (json['facility_booking_slots'] != null) {
      facilityBookingSlots = <FacilityBookingSlots>[];
      json['facility_booking_slots'].forEach((v) {
        facilityBookingSlots!.add(new FacilityBookingSlots.fromJson(v));
      });
    }
    payment =
        json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
    bookingCancellationRequest =
        json['booking_cancellation_request'] != null
            ? new BookingCancellationRequest.fromJson(
              json['booking_cancellation_request'],
            )
            : null;
    cancellationStatus = json['cancellation_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['user_or_owner_id'] = this.userOrOwnerId;
    if (this.facilityBookingSlots != null) {
      data['facility_booking_slots'] =
          this.facilityBookingSlots!.map((v) => v.toJson()).toList();
    }
    if (this.payment != null) {
      data['payment'] = this.payment!.toJson();
    }
    if (this.bookingCancellationRequest != null) {
      data['booking_cancellation_request'] =
          this.bookingCancellationRequest!.toJson();
    }
    data['cancellation_status'] = this.cancellationStatus;
    return data;
  }
}

class CancelledBookings {
  int? bookingId;
  String? startDate;
  String? endDate;
  int? userOrOwnerId;
  List<FacilityBookingSlots>? facilityBookingSlots;
  Payment? payment;
  BookingCancellationRequest? bookingCancellationRequest;
  String? cancellationStatus;

  CancelledBookings({
    this.bookingId,
    this.startDate,
    this.endDate,
    this.userOrOwnerId,
    this.facilityBookingSlots,
    this.payment,
    this.bookingCancellationRequest,
    this.cancellationStatus,
  });

  CancelledBookings.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    userOrOwnerId = json['user_or_owner_id'];
    if (json['facility_booking_slots'] != null) {
      facilityBookingSlots = <FacilityBookingSlots>[];
      json['facility_booking_slots'].forEach((v) {
        facilityBookingSlots!.add(new FacilityBookingSlots.fromJson(v));
      });
    }
    payment =
        json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
    bookingCancellationRequest =
        json['booking_cancellation_request'] != null
            ? new BookingCancellationRequest.fromJson(
              json['booking_cancellation_request'],
            )
            : null;
    cancellationStatus = json['cancellation_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['user_or_owner_id'] = this.userOrOwnerId;
    if (this.facilityBookingSlots != null) {
      data['facility_booking_slots'] =
          this.facilityBookingSlots!.map((v) => v.toJson()).toList();
    }
    if (this.payment != null) {
      data['payment'] = this.payment!.toJson();
    }
    if (this.bookingCancellationRequest != null) {
      data['booking_cancellation_request'] =
          this.bookingCancellationRequest!.toJson();
    }
    data['cancellation_status'] = this.cancellationStatus;
    return data;
  }
}

class FacilityBookingSlots {
  int? bookingId;
  int? unitId;
  String? bookingDate;
  String? startTime;
  String? endTime;
  String? day;
  String? transactionStatus;
  int? facilityId;
  int? serviceId;
  Unit? unit;
  Facility? facility;
  Service? service;

  FacilityBookingSlots({
    this.bookingId,
    this.unitId,
    this.bookingDate,
    this.startTime,
    this.endTime,
    this.day,
    this.transactionStatus,
    this.facilityId,
    this.serviceId,
    this.unit,
    this.facility,
    this.service,
  });

  FacilityBookingSlots.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    unitId = json['unit_id'];
    bookingDate = json['booking_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    day = json['day'];
    transactionStatus = json['transaction_status'];
    facilityId = json['facility_id'];
    serviceId = json['service_id'];
    unit = json['unit'] != null ? new Unit.fromJson(json['unit']) : null;
    facility =
        json['facility'] != null
            ? new Facility.fromJson(json['facility'])
            : null;
    service =
        json['service'] != null ? new Service.fromJson(json['service']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['unit_id'] = this.unitId;
    data['booking_date'] = this.bookingDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['day'] = this.day;
    data['transaction_status'] = this.transactionStatus;
    data['facility_id'] = this.facilityId;
    data['service_id'] = this.serviceId;
    if (this.unit != null) {
      data['unit'] = this.unit!.toJson();
    }
    if (this.facility != null) {
      data['facility'] = this.facility!.toJson();
    }
    if (this.service != null) {
      data['service'] = this.service!.toJson();
    }
    return data;
  }
}

class Unit {
  int? unitId;
  String? unitName;

  Unit({this.unitId, this.unitName});

  Unit.fromJson(Map<String, dynamic> json) {
    unitId = json['unit_id'];
    unitName = json['unit_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unit_id'] = this.unitId;
    data['unit_name'] = this.unitName;
    return data;
  }
}

class Facility {
  int? facilityId;
  String? facilityName;
  String? address;
  String? city;
  String? state;
  String? zipcode;
  List<FacilityImages>? facilityImages;
  Feedback? feedback;

  Facility({
    this.facilityId,
    this.facilityName,
    this.address,
    this.city,
    this.state,
    this.zipcode,
    this.facilityImages,
    this.feedback,
  });

  Facility.fromJson(Map<String, dynamic> json) {
    facilityId = json['facility_id'];
    facilityName = json['facility_name'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zipcode = json['zipcode'];
    if (json['facility_images'] != null) {
      facilityImages = <FacilityImages>[];
      json['facility_images'].forEach((v) {
        facilityImages!.add(new FacilityImages.fromJson(v));
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
    if (this.facilityImages != null) {
      data['facility_images'] =
          this.facilityImages!.map((v) => v.toJson()).toList();
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

class Feedback {
  dynamic averageRating;
  int? totalCount;

  Feedback({this.averageRating, this.totalCount});

  Feedback.fromJson(Map<String, dynamic> json) {
    averageRating = json['averageRating'];
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['averageRating'] = this.averageRating;
    data['totalCount'] = this.totalCount;
    return data;
  }
}

class Service {
  int? serviceId;
  String? serviceName;

  Service({this.serviceId, this.serviceName});

  Service.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    serviceName = json['service_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
    return data;
  }
}

class Payment {
  int? paymentId;
  int? collectPayment;

  Payment({this.paymentId, this.collectPayment});

  Payment.fromJson(Map<String, dynamic> json) {
    paymentId = json['payment_id'];
    collectPayment = json['collect_payment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_id'] = this.paymentId;
    data['collect_payment'] = this.collectPayment;
    return data;
  }
}

class BookingCancellationRequest {
  int? bookingId;
  String? status;

  BookingCancellationRequest({this.bookingId, this.status});

  BookingCancellationRequest.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['status'] = this.status;
    return data;
  }
}
