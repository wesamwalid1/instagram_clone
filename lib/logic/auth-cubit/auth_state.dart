part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);
}

final class AuthSuccess extends AuthState {
  final User user;
  final UserModel? userModel;

  AuthSuccess(this.user, {this.userModel});
}

final class AuthProfileUpdateSuccess extends AuthState {
  final User user;
  final UserModel? userModel;

  AuthProfileUpdateSuccess(this.user, {this.userModel});
}

final class AuthProfilePhotoUpdateLoading extends AuthState {}

final class AuthProfilePhotoUpdateSuccess extends AuthState {
  final User user;
  final UserModel userModel;

  AuthProfilePhotoUpdateSuccess(this.user, this.userModel);
}

final class AuthProfilePhotoUpdateFailure extends AuthState {
  final String error;

  AuthProfilePhotoUpdateFailure(this.error);
}

final class SignOut extends AuthState {}

// New state to hold search results
final class AuthSearchResults extends AuthState {
  final List<UserModel> searchResults;

  AuthSearchResults(this.searchResults);
}

final class FetchUsersLoading extends AuthState {}
final class FetchUsersSuccess extends AuthState {
  final List<UserModel> users;
  FetchUsersSuccess(this.users);
}
final class FetchUsersError extends AuthState {
  final String error;
  FetchUsersError(this.error);
}

final class AuthLoginSuccess extends AuthState {
  final User user;
  final UserModel? userModel;

  AuthLoginSuccess(this.user, {this.userModel});
}

final class AuthRegisterSuccess extends AuthState {
  final User user;

  AuthRegisterSuccess(this.user);
}


