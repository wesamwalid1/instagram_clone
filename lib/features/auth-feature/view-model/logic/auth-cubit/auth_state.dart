part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}
final class AuthLoading extends AuthState {}
final class AuthSuccess extends AuthState {
  final User user;

  AuthSuccess(this.user);
}
final class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);
}