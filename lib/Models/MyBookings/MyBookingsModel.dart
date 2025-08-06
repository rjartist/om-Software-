class MyBookingsModel {
  final bool? success;
  final String? message;
  final int? totalBookingCount;
  final int? upcomingBookingCount;
  final int? pastBookingCount;
  final int? cancelledBookingCount;
  final List<PastBookings>? pastBookings;
  final List<FutureBookings>? futureBookings;
  final List<CancelledBookings>? cancelledBookings;

  MyBookingsModel({
    this.success,
    this.message,
    this.totalBookingCount,
    this.upcomingBookingCount,
    this.pastBookingCount,
    this.cancelledBookingCount,
    this.pastBookings,
    this.futureBookings,
    this.cancelledBookings,
  });

  factory MyBookingsModel.fromJson(Map<String, dynamic> json) {
    return MyBookingsModel(
      success: json['success'],
      message: json['message'],
      totalBookingCount: json['totalBookingCount'],
      upcomingBookingCount: json['upcomingBookingCount'],
      pastBookingCount: json['pastBookingCount'],
      cancelledBookingCount: json['cancelledBookingCount'],
      pastBookings:
          (json['pastBookings'] as List<dynamic>?)
              ?.map((e) => PastBookings.fromJson(e))
              .toList(),
      futureBookings:
          (json['futureBookings'] as List<dynamic>?)
              ?.map((e) => FutureBookings.fromJson(e))
              .toList(),
      cancelledBookings:
          (json['cancelledBookings'] as List<dynamic>?)
              ?.map((e) => CancelledBookings.fromJson(e))
              .toList(),
    );
  }
}

class PastBookings {
  int? bookingId;
  String? startDate;
  String? endDate;
  int? userOrOwnerId;

  // New fields from API
  String? totalAmount;
  String? totalDiscount;
  String? totalCollectPayment;
  String? convenienceFees;

  List<FacilityBookingSlots>? facilityBookingSlots;
  Payment? payment;
  BookingCancellationRequest? bookingCancellationRequest;
  List<UserCoinTransactions>? userCoinTransactions;
  String? cancellationStatus;
  bool? coinsUsed;
  int? coinsUsedCount;

  PastBookings({
    this.bookingId,
    this.startDate,
    this.endDate,
    this.userOrOwnerId,
    this.totalAmount,
    this.totalDiscount,
    this.totalCollectPayment,
    this.convenienceFees,
    this.facilityBookingSlots,
    this.payment,
    this.bookingCancellationRequest,
    this.userCoinTransactions,
    this.cancellationStatus,
    this.coinsUsed,
    this.coinsUsedCount,
  });

  PastBookings.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    userOrOwnerId = json['user_or_owner_id'];
    totalAmount = json['total_amount'];
    totalDiscount = json['total_discount'];
    totalCollectPayment = json['total_collect_payment'];
    convenienceFees = json['convenience_fees'];

    if (json['facility_booking_slots'] != null) {
      facilityBookingSlots = <FacilityBookingSlots>[];
      json['facility_booking_slots'].forEach((v) {
        facilityBookingSlots!.add(FacilityBookingSlots.fromJson(v));
      });
    }

    payment =
        json['payment'] != null ? Payment.fromJson(json['payment']) : null;

    bookingCancellationRequest =
        json['booking_cancellation_request'] != null
            ? BookingCancellationRequest.fromJson(
              json['booking_cancellation_request'],
            )
            : null;

    if (json['user_coin_transactions'] != null) {
      userCoinTransactions = <UserCoinTransactions>[];
      json['user_coin_transactions'].forEach((v) {
        userCoinTransactions!.add(UserCoinTransactions.fromJson(v));
      });
    }

    cancellationStatus = json['cancellation_status'];
    coinsUsed = json['coins_used'];
    coinsUsedCount = json['coins_used_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['booking_id'] = bookingId;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['user_or_owner_id'] = userOrOwnerId;
    data['total_amount'] = totalAmount;
    data['total_discount'] = totalDiscount;
    data['total_collect_payment'] = totalCollectPayment;
    data['convenience_fees'] = convenienceFees;

    if (facilityBookingSlots != null) {
      data['facility_booking_slots'] =
          facilityBookingSlots!.map((v) => v.toJson()).toList();
    }

    if (payment != null) {
      data['payment'] = payment!.toJson();
    }

    if (bookingCancellationRequest != null) {
      data['booking_cancellation_request'] =
          bookingCancellationRequest!.toJson();
    }

    if (userCoinTransactions != null) {
      data['user_coin_transactions'] =
          userCoinTransactions!.map((v) => v.toJson()).toList();
    }

    data['cancellation_status'] = cancellationStatus;
    data['coins_used'] = coinsUsed;
    data['coins_used_count'] = coinsUsedCount;

    return data;
  }
}

class FutureBookings {
  int? bookingId;
  String? startDate;
  String? endDate;
  int? userOrOwnerId;

  String? totalAmount;
  String? totalDiscount;
  String? totalCollectPayment;
  String? convenienceFees;

  List<FacilityBookingSlots>? facilityBookingSlots;
  Payment? payment;
  BookingCancellationRequest? bookingCancellationRequest;
  String? cancellationStatus;
  bool? coinsUsed;
  int? coinsUsedCount;
  List<UserCoinTransactions>? userCoinTransactions;

  FutureBookings({
    this.bookingId,
    this.startDate,
    this.endDate,
    this.userOrOwnerId,
    this.totalAmount,
    this.totalDiscount,
    this.totalCollectPayment,
    this.convenienceFees,
    this.facilityBookingSlots,
    this.payment,
    this.bookingCancellationRequest,
    this.cancellationStatus,
    this.coinsUsed,
    this.coinsUsedCount,
    this.userCoinTransactions,
  });

  FutureBookings.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    userOrOwnerId = json['user_or_owner_id'];
    totalAmount = json['total_amount'];
    totalDiscount = json['total_discount'];
    totalCollectPayment = json['total_collect_payment'];
    convenienceFees = json['convenience_fees'];
    coinsUsed = json['coins_used'];
    coinsUsedCount = json['coins_used_count'];

    if (json['facility_booking_slots'] != null) {
      facilityBookingSlots = <FacilityBookingSlots>[];
      json['facility_booking_slots'].forEach((v) {
        facilityBookingSlots!.add(FacilityBookingSlots.fromJson(v));
      });
    }

    if (json['payment'] != null) {
      payment = Payment.fromJson(json['payment']);
    }

    if (json['booking_cancellation_request'] != null) {
      bookingCancellationRequest = BookingCancellationRequest.fromJson(
        json['booking_cancellation_request'],
      );
    }

    cancellationStatus = json['cancellation_status'];

    if (json['user_coin_transactions'] != null) {
      userCoinTransactions = <UserCoinTransactions>[];
      json['user_coin_transactions'].forEach((v) {
        userCoinTransactions!.add(UserCoinTransactions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['booking_id'] = bookingId;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['user_or_owner_id'] = userOrOwnerId;
    data['total_amount'] = totalAmount;
    data['total_discount'] = totalDiscount;
    data['total_collect_payment'] = totalCollectPayment;
    data['convenience_fees'] = convenienceFees;
    data['coins_used'] = coinsUsed;
    data['coins_used_count'] = coinsUsedCount;

    if (facilityBookingSlots != null) {
      data['facility_booking_slots'] =
          facilityBookingSlots!.map((v) => v.toJson()).toList();
    }

    if (payment != null) {
      data['payment'] = payment!.toJson();
    }

    if (bookingCancellationRequest != null) {
      data['booking_cancellation_request'] =
          bookingCancellationRequest!.toJson();
    }

    data['cancellation_status'] = cancellationStatus;

    if (userCoinTransactions != null) {
      data['user_coin_transactions'] =
          userCoinTransactions!.map((v) => v.toJson()).toList();
    }

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
  List<UserCoinTransactions>? userCoinTransactions;
  String? cancellationStatus;
  bool? coinsUsed;
  int? coinsUsedCount;

  CancelledBookings({
    this.bookingId,
    this.startDate,
    this.endDate,
    this.userOrOwnerId,
    this.facilityBookingSlots,
    this.payment,
    this.bookingCancellationRequest,
    this.userCoinTransactions,
    this.cancellationStatus,
    this.coinsUsed,
    this.coinsUsedCount,
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
    if (json['user_coin_transactions'] != null) {
      userCoinTransactions = <UserCoinTransactions>[];
      json['user_coin_transactions'].forEach((v) {
        userCoinTransactions!.add(new UserCoinTransactions.fromJson(v));
      });
    }
    cancellationStatus = json['cancellation_status'];
    coinsUsed = json['coins_used'];
    coinsUsedCount = json['coins_used_count'];
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
    if (this.userCoinTransactions != null) {
      data['user_coin_transactions'] =
          this.userCoinTransactions!.map((v) => v.toJson()).toList();
    }
    data['cancellation_status'] = this.cancellationStatus;
    data['coins_used'] = this.coinsUsed;
    data['coins_used_count'] = this.coinsUsedCount;
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
  String? collectPayment;
  String? paymentMethod;
  String? createdAt;
  String? coinDiscount;
  String? platformFees;
  String? gst;
  String? paymentDate;
  String? paymentTime;
  String? couponDiscount;

  Payment({
    this.paymentId,
    this.collectPayment,
    this.paymentMethod,
    this.createdAt,
    this.coinDiscount,
    this.platformFees,
    this.gst,
    this.paymentDate,
    this.paymentTime,
    this.couponDiscount,
  });

  Payment.fromJson(Map<String, dynamic> json) {
    paymentId = json['payment_id'];
    collectPayment = json['collect_payment'];
    paymentMethod = json['payment_method'];
    createdAt = json['created_at'];
    coinDiscount = json['coin_discount'];
    platformFees = json['platform_fees'];
    gst = json['gst'];
    paymentDate = json['payment_date'];
    paymentTime = json['payment_time'];
    couponDiscount = json['coupon_discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['payment_id'] = paymentId;
    data['collect_payment'] = collectPayment;
    data['payment_method'] = paymentMethod;
    data['created_at'] = createdAt;
    data['coin_discount'] = coinDiscount;
    data['platform_fees'] = platformFees;
    data['gst'] = gst;
    data['payment_date'] = paymentDate;
    data['payment_time'] = paymentTime;
    data['coupon_discount'] = couponDiscount;
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

class UserCoinTransactions {
  String? status;
  int? usedCoins;

  UserCoinTransactions({this.status, this.usedCoins});

  UserCoinTransactions.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    usedCoins = json['used_coins'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['used_coins'] = this.usedCoins;
    return data;
  }
}
