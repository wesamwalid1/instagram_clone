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
  List<String>? followers;
  List<String>? following;
  int? followersCount;
  int? followingCount;
  int? postsCount;  // Add postsCount field
  List<String>? participants;

  UserModel({
    this.uid,
    this.username,
    this.email,
    this.profilePhoto,
    this.gender,
    this.phone,
    this.bio,
    this.website,
    this.name,
    this.followers,
    this.following,
    this.followersCount,
    this.followingCount,
    this.postsCount,  // Add postsCount in constructor
    this.participants,
  });

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
      "followers": followers,
      "following": following,
      "followersCount": followersCount,
      "followingCount": followingCount,
      "postsCount": postsCount,  // Include postsCount in map
      'participants':participants,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map["uid"],
      profilePhoto: map["profilePhoto"],
      name: map["name"],
      username: map["username"],
      website: map["website"],
      bio: map["bio"],
      email: map["email"],
      phone: map["phone"],
      gender: map["gender"],
      followers: List<String>.from(map["followers"] ?? []), // Cast to List<String>
      following: List<String>.from(map["following"] ?? []), // Cast to List<String>
      followersCount: map["followersCount"],
      followingCount: map["followingCount"],
      postsCount: map["postsCount"],  // Include postsCount when constructing
      participants: map['participants']
    );
  }
}
