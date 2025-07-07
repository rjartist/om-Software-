class ProductModel {
  final int id;
  final String name;
  final String image;
  final double price;
  final double? originalPrice;
  final String? discountLabel;
  final String quantity;
  int userSelectedQuantity;

  ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.originalPrice,
    this.discountLabel,
    required this.quantity,
    this.userSelectedQuantity = 1,
  });

  factory ProductModel.fromMap(String idKey, Map<String, dynamic> data) {
    return ProductModel(
      id: data['id'] is int
          ? data['id']
          : int.tryParse(data['id'].toString()) ?? 0,
      name: data['name']?.toString() ?? '',
      image: data['image']?.toString() ?? '',
      price: double.tryParse(data['price'].toString()) ?? 0.0,
      originalPrice: data['originalPrice'] != null
          ? double.tryParse(data['originalPrice'].toString())
          : null,
      discountLabel: data['discountLabel']?.toString(),
      quantity: data['quantity']?.toString() ?? '',
      userSelectedQuantity: 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'originalPrice': originalPrice,
      'discountLabel': discountLabel,
      'quantity': quantity,
      'userSelectedQuantity': userSelectedQuantity,
    };
  }
}
