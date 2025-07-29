class CouponModel {
  final int couponId;
  final String couponCode;
  final int? discountPercentage;
  final int? discountAmount;
  final String expiryDate;

  CouponModel({
    required this.couponId,
    required this.couponCode,
    this.discountPercentage,
    this.discountAmount,
    required this.expiryDate,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      couponId: json['coupon_id'] ?? 0,
      couponCode: json['coupon_code'] ?? '',
      discountPercentage: json['discount_percentage'],
      discountAmount: json['discount_amount'],
      expiryDate: json['expiry_date'] ?? '',
    );
  }
}
