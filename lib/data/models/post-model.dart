class PostModel {
  String? postId;
  String? uid;
  List<String>? mediaUrls; // Images/Videos URLs
  String? description;
  String? location;
  String? username;
  String? userImage;
  String? mediaType; // 'image', 'video', 'carousel'
  List<String>? likes;
  bool likePost;
  //List<String>? saves;
  bool isSaved;
  DateTime? createdAt;

  PostModel({
    this.postId,
    this.uid,
    this.mediaUrls,
    this.description,
    this.location,
    this.username,
    this.userImage,
    this.mediaType,
    this.likes = const [],
    this.likePost = false,
   // this.saves = const [],
    this.isSaved = false,
    this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'postId': postId,
    'uid': uid,
    'mediaUrls': mediaUrls,
    'description': description,
    'location': location,
    'username': username,
    'userImage': userImage,
    'mediaType': mediaType,
    'likes': likes,
    //'saves': saves,
    'isSaved': isSaved,
    'createdAt': createdAt?.toIso8601String(),
  };

  factory PostModel.fromMap(Map<String, dynamic> map, {String? currentUserId}) {
    List<String> likesList = List<String>.from(map['likes'] ?? []);
    return PostModel(
      postId: map['postId'],
      uid: map['uid'],
      mediaUrls: List<String>.from(map['mediaUrls'] ?? []),
      description: map['description'] ?? '',
      location: map['location'],
      username: map['username'] ?? '',
      userImage: map['userImage'] ?? '',
      mediaType: map['mediaType'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      likes: likesList,
      likePost: likesList.contains(currentUserId),
      isSaved: map['isSaved'] ?? false,
    );
  }

  void toggleLike(String userId) {
    if (likes == null) {
      likes = [];
    }
    if (likePost) {
      likes!.remove(userId);
      likePost = false;
    } else {
      likes!.add(userId);
      likePost = true;
    }
  }
}



