part of 'post_cubit.dart';

@immutable
abstract class PostState {}

class PostInitial extends PostState {}

class PostUploading extends PostState {}

class PostUploadSuccess extends PostState {
  final String downloadUrl;

  PostUploadSuccess(this.downloadUrl);
}

class PostUploadFailure extends PostState {
  final String error;

  PostUploadFailure(this.error);
}

// New states for loading posts
class PostLoading extends PostState {}

class PostLoadSuccess extends PostState {
  final List<PostModel> posts;

  PostLoadSuccess(this.posts);
}

class PostLoadFailure extends PostState {
  final String error;

  PostLoadFailure(this.error);
}

class PostFavoritedToggle extends PostState {
  final String postId;
  final bool isFavorited;

  PostFavoritedToggle(this.postId, {required this.isFavorited});
}
class PostSavedToggle extends PostState {
  final String postId;
  final bool isSaved;

  PostSavedToggle({required this.postId, required this.isSaved});
}

// class PostLikeSuccess extends PostState {
//   final int newLikes;
//
//   PostLikeSuccess(this.newLikes);
// }
//
// class PostLikeFailure extends PostState {
//   final String error;
//
//   PostLikeFailure(this.error);
// }





