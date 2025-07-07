class GroceryCategoryModel {
  final int id;
  final String title;
  final String image;

  GroceryCategoryModel({
    required this.id,
    required this.title,
    required this.image,
  });

  factory GroceryCategoryModel.fromJson(Map<String, dynamic> json) {
    return GroceryCategoryModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'image': image,
      };
}
