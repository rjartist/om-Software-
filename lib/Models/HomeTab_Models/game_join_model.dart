class GameJoinModel {
  final String gameName;
  final String date;
  final String time; // "8 AM - 9 PM"
  final String address;
  final String hostName;
  final String hostPhoto;
  final List<MemberModel> members;

  GameJoinModel({
    required this.gameName,
    required this.date,
    required this.time,
    required this.address,
    required this.hostName,
    required this.hostPhoto,
    required this.members,
  });

  factory GameJoinModel.fromJson(Map<String, dynamic> json) {
    return GameJoinModel(
      gameName: json['gameName'],
      date: json['date'],
      time: json['time'],
      address: json['address'],
      hostName: json['hostName'],
      hostPhoto: json['hostPhoto'],
      members: (json['members'] as List<dynamic>)
          .map((e) => MemberModel.fromJson(e))
          .toList(),
    );
  }
}


class MemberModel {
  final String name;
  final String photo;

  MemberModel({
    required this.name,
    required this.photo,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      name: json['name'],
      photo: json['photo'],
    );
  }
}
