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
  final List<Map<String, dynamic>> posts;

  PostLoadSuccess(this.posts);
}

class PostLoadFailure extends PostState {
  final String error;

  PostLoadFailure(this.error);
}
