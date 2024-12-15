// story_model.dart
class StoryModel {
  String? storyId;
  String? userId;
  String? username;
  String? profilePhoto;
  DateTime? timestamp;
  bool? isVideo;
  List<String>? mediaUrls;
  List<String>? viewers;

  StoryModel(
      {this.storyId,
      this.userId,
      this.username,
      this.profilePhoto,
      this.timestamp,
      this.mediaUrls,
      this.isVideo,
      this.viewers});

  // Convert to map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'storyId': storyId,
      'userId': userId,
      'username': username,
      'profilePhoto': profilePhoto,
      'timestamp': timestamp?.millisecondsSinceEpoch,
      'mediaUrls': mediaUrls,
      'isVideo': isVideo,
      'viewers': viewers,
    };
  }

  // Convert from map
  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      storyId: map['storyId'],
      userId: map['userId'],
      username: map['username'],
      profilePhoto: map['profilePhoto'],
      mediaUrls: List<String>.from(map['mediaUrls'] ?? []),
      isVideo: map['isVideo'],
      viewers: List<String>.from(map['viewers'] ?? []),
      timestamp: map['timestamp'] is int
          ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'])
          : map['createdAt']?.toDate(),
    );
  }
}
