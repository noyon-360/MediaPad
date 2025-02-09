part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  const LoginEvent(this.email,this.password);

  @override
  // TODO: implement props
  List<Object?> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  const RegisterEvent(this.name,this.email, this.password, this.confirmPassword);

  @override
  // TODO: implement props
  List<Object?> get props => [name, email, password, confirmPassword];
}

class LogoutEvent extends AuthEvent {}