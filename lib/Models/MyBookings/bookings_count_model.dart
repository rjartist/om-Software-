class BookingCount {
  bool? success;
  String? message;
  dynamic totalBookingCount;
  dynamic upcomingBookingCount;
  dynamic pastBookingCount;
  dynamic cancelledBookingCount;

  BookingCount(
      {this.success,
      this.message,
      this.totalBookingCount,
      this.upcomingBookingCount,
      this.pastBookingCount,
      this.cancelledBookingCount});

  BookingCount.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    totalBookingCount = json['totalBookingCount'];
    upcomingBookingCount = json['upcomingBookingCount'];
    pastBookingCount = json['pastBookingCount'];
    cancelledBookingCount = json['cancelledBookingCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['totalBookingCount'] = this.totalBookingCount;
    data['upcomingBookingCount'] = this.upcomingBookingCount;
    data['pastBookingCount'] = this.pastBookingCount;
    data['cancelledBookingCount'] = this.cancelledBookingCount;
    return data;
  }
}