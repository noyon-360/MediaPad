part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}

class Authenticated  extends AuthState {
  final UserModel user;

  const Authenticated({required this.user});

  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

// class AuthSuccess extends AuthState {
//   final UserModel user;
//   const AuthSuccess(this.user);
// }

class AuthFailure extends AuthState {
  final String error;
  const AuthFailure({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
