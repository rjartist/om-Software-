class MyOrderModel {
  final int id;
  final String status;
  final DateTime date;
  final double totalAmount;

  MyOrderModel({
    required this.id,
    required this.status,
    required this.date,
    required this.totalAmount,
  });

  factory MyOrderModel.fromJson(Map<String, dynamic> json) {
    return MyOrderModel(
      id: json['id'],
      status: json['status'],
      date: DateTime.parse(json['date']),
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );
  }
}
