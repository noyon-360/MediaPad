import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:media_pad/data/api/auth_repository.dart';
import 'package:media_pad/data/models/user_model.dart';
import 'package:media_pad/presentation/bloc/media_pad_note/media_notes_bloc.dart';


part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    // On Auth Initialize
    on<AppStarted>((event, emit) async {
      final user = await authRepository.getUser();
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(Unauthenticated());
      }
    });

    // User Register
    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        await authRepository.register(
            event.name, event.email, event.password, event.confirmPassword);

        emit(AuthInitial());
      } catch (e) {
        emit(AuthFailure(error: e.toString()));
        emit(Unauthenticated());
      }
    });

    // User Login
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {

        final user = await authRepository.login(
            event.email, event.password);
        print(user.token);
        emit(Authenticated(user: user));
      } catch (e) {
        print("login error");
        emit(AuthFailure(error: e.toString()));
        emit(Unauthenticated());
      }
    });

    // Logout User
    on<LogoutEvent>((event, emit) async {
      await authRepository.logout();
      emit(Unauthenticated()); // Emit unauthenticated state
    });
  }
}