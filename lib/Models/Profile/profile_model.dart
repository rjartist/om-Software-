class ProfileModel {
  bool? success;
  String? message;
  User? user;

  ProfileModel({this.success, this.message, this.user});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? userId;
  String? name;
  String? email;
  String? phoneNumber;
  String? birthdate;
  String? gender;
  String? profileImage;

  User({
    this.userId,
    this.name,
    this.email,
    this.phoneNumber,
    this.birthdate,
    this.gender,
    this.profileImage,
  });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    birthdate = json['birthdate'];
    gender = json['gender'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'name': name,
        'email': email,
        'phone_number': phoneNumber,
        'birthdate': birthdate,
        'gender': gender,
        'profile_image': profileImage,
      };
}