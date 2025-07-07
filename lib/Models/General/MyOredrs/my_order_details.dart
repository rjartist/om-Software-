class MyOrderDetailModel {
  final int id;
  final String status;
  final DateTime date;
  final double totalAmount;
  final String paymentMethod;
  final String deliveryAddress;
  final double deliveryCharge;
  final List<OrderItemModel> items;

  MyOrderDetailModel({
    required this.id,
    required this.status,
    required this.date,
    required this.totalAmount,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.deliveryCharge,
    required this.items,
  });

  factory MyOrderDetailModel.fromJson(Map<String, dynamic> json) {
    return MyOrderDetailModel(
      id: json['id'],
      status: json['status'],
      date: DateTime.parse(json['date']),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'],
      deliveryAddress: json['deliveryAddress'],
      deliveryCharge: (json['deliveryCharge'] as num).toDouble(),
      items: (json['items'] as List)
          .map((item) => OrderItemModel.fromJson(item))
          .toList(),
    );
  }
}



class OrderItemModel {
  final int productId;
  final String name;
  final String image;
  final int quantity;
  final double price;
  final double? originalPrice;
  final String? discountLabel;
  final String unit;

  OrderItemModel({
    required this.productId,
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
    this.originalPrice,
    this.discountLabel,
    required this.unit,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId'],
      name: json['name'],
      image: json['image'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      originalPrice: json['originalPrice'] != null
          ? (json['originalPrice'] as num).toDouble()
          : null,
      discountLabel: json['discountLabel'],
      unit: json['unit'] ?? '',
    );
  }
}
