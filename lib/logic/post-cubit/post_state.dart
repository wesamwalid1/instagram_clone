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
