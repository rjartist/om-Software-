import 'package:gkmarts/Models/MyBookings/MyBookingsModel.dart';

class BookingItem {
  int? bookingId;
  String? startDate;
  String? endDate;
  int? userOrOwnerId;
  List<FacilityBookingSlots>? facilityBookingSlots;
  Payment? payment;
  BookingCancellationRequest? bookingCancellationRequest;
  String? cancellationStatus;

  BookingItem(
      {this.bookingId,
      this.startDate,
      this.endDate,
      this.userOrOwnerId,
      this.facilityBookingSlots,
      this.payment,
      this.bookingCancellationRequest,
      this.cancellationStatus});

  BookingItem.fromJson(Map<String, dynamic> json) {
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
    bookingCancellationRequest = json['booking_cancellation_request'] != null
        ? new BookingCancellationRequest.fromJson(
            json['booking_cancellation_request'])
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