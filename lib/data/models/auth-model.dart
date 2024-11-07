class UserModel {
  String? uid;
  String? profilePhoto;
  String? name;
  String? username;
  String? website;
  String? bio;
  String? email;
  String? phone;
  String? gender;

  UserModel({this.uid, this.username, this.email, this.profilePhoto,this.gender,this.phone,this.bio,this.website,this.name});

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "profilePhoto": profilePhoto,
      "name": name,
      "username": username,
      "website": website,
      "bio": bio,
      "email": email,
      "phone": phone,
      "gender": gender,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map["uid"],
      profilePhoto: map["profilePhoto"],
      name:map["name"],
      username: map["username"],
      website: map["website"],
      bio: map["bio"],
      email: map["email"],
      phone: map["phone"],
      gender: map["gender"],
    );
  }
}
