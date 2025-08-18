class GenerateReferralLink {
  bool? success;
  String? referralCode;
  String? referralLink;

  GenerateReferralLink({this.success, this.referralCode, this.referralLink});

  GenerateReferralLink.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    referralCode = json['referral_code'];
    referralLink = json['referral_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['referral_code'] = this.referralCode;
    data['referral_link'] = this.referralLink;
    return data;
  }
}