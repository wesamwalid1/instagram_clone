class PostModel {
  String? uid;
  String? postImage;
  String? description;
  String? location;
  String? username;
  String? userImage;


  PostModel({this.uid,  this.postImage, this.description, this.location,this.username,this.userImage});

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "postImage": postImage,
      "description": description,
      "location": location,
      "username":username,
      "userImage":userImage
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      uid: map["uid"],
      postImage: map["postImage"],
      description: map["description"],
      location: map["location"],
      username: map["username"],
      userImage: map["userImage"],
    );
  }
}
