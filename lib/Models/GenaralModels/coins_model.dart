class CoinsModel {
  final int coinWalletId;
  final int totalCoins;
  final int remainingBonusCoins;
  final int bonusBookingsUsed;
  final DateTime bonusExpiry;
  final Referral referral;

  CoinsModel({
    required this.coinWalletId,
    required this.totalCoins,
    required this.remainingBonusCoins,
    required this.bonusBookingsUsed,
    required this.bonusExpiry,
    required this.referral,
  });

   int get totalCoinsWithReferral => totalCoins + referral.totalReferralPoints;

  factory CoinsModel.fromJson(Map<String, dynamic> json) {
    return CoinsModel(
      coinWalletId: json['coin_wallet_id'] ?? 0,
      totalCoins: json['total_coins'] ?? 0,
      remainingBonusCoins: json['remaining_bonus_coins'] ?? 0,
      bonusBookingsUsed: json['bonus_bookings_used'] ?? 0,
      bonusExpiry: DateTime.tryParse(json['bonus_expiry'] ?? '') ?? DateTime.now(),
      referral: Referral.fromJson(json['referral'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "coin_wallet_id": coinWalletId,
      "total_coins": totalCoins,
      "remaining_bonus_coins": remainingBonusCoins,
      "bonus_bookings_used": bonusBookingsUsed,
      "bonus_expiry": bonusExpiry.toIso8601String(),
      "referral": referral.toJson(),
    };
  }
}

class Referral {
  final int totalReferralPoints;
  final int usedReferralPoints;
  final int remainingReferralPoints;
  final String? nextReferralEntry;

  Referral({
    required this.totalReferralPoints,
    required this.usedReferralPoints,
    required this.remainingReferralPoints,
    this.nextReferralEntry,
  });

  factory Referral.fromJson(Map<String, dynamic> json) {
    return Referral(
      totalReferralPoints: json['total_referral_points'] ?? 0,
      usedReferralPoints: json['used_referral_points'] ?? 0,
      remainingReferralPoints: json['remaining_referral_points'] ?? 0,
      nextReferralEntry: json['next_referral_entry'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "total_referral_points": totalReferralPoints,
      "used_referral_points": usedReferralPoints,
      "remaining_referral_points": remainingReferralPoints,
      "next_referral_entry": nextReferralEntry,
    };
  }
}
