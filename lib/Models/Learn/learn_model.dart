class GameModel {
  final int id;
  final String title;

  GameModel({
    required this.id,
    required this.title,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'],
      title: json['title'],
    );
  }
}
