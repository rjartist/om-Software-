class CoinsModel {
  final int totalCoins;
  final int remainingBonusCoins;
  final int bonusBookingsUsed;
  final DateTime bonusExpiry;
  final int coinwalletid;

  CoinsModel({
    required this.totalCoins,
    required this.remainingBonusCoins,
    required this.bonusBookingsUsed,
    required this.bonusExpiry,
    required this.coinwalletid,
  });

  factory CoinsModel.fromJson(Map<String, dynamic> json) {
    return CoinsModel(
      totalCoins: json['total_coins'] ?? 0,
      remainingBonusCoins: json['remaining_bonus_coins'] ?? 0,
      bonusBookingsUsed: json['bonus_bookings_used'] ?? 0,
      bonusExpiry: DateTime.parse(json['bonus_expiry']),
      coinwalletid: json['coin_wallet_id'] ?? 0,
    );
  }
}
