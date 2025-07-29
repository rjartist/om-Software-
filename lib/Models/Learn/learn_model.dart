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



class VlogModel {
  final int id;
  final String title;
  final String description;

  final String datePost;
  final String imageUrl;

  VlogModel({
    required this.id,
    required this.title,
    required this.description,

    required this.datePost,
    required this.imageUrl,
  });

  factory VlogModel.fromJson(Map<String, dynamic> json) {
    return VlogModel(
      id: json['id']??0,
      title: json['title']??"",
      description: json['description']??"",
   
      datePost: json['datePost']??"",
      imageUrl: json['imageUrl']??"",
    );
  }
}
