import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_pad/config/route/routes.dart';
import 'package:media_pad/config/route/routes_name.dart';
import 'package:media_pad/core/constants.dart';
import 'package:media_pad/core/theme.dart';
import 'package:media_pad/data/api/note_services.dart';
import 'package:media_pad/data/api/auth_repository.dart';
import 'package:media_pad/data/models/user_model.dart';
import 'package:media_pad/presentation/bloc/Authentication/auth_bloc.dart';
import 'package:media_pad/presentation/bloc/media_pad_note/media_notes_bloc.dart';
import 'package:media_pad/presentation/pages/AuthScreens/login_page.dart';
import 'package:media_pad/presentation/pages/notes_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authRepository = AuthRepository();
  final initialUser = await authRepository.getUser();
  runApp(MyApp(
    apiService: ApiService(),
    authRepository: authRepository,
    initialUser: initialUser
  ));
}

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
    required this.apiService,
    required this.authRepository,
    this.initialUser
  });

  final AuthRepository authRepository;
  final ApiService apiService;

  final UserModel? initialUser;

  // Create a global navigator key
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => MediaNotesBloc(apiService: apiService)
                ..add(LoadNotesEvent())),
          BlocProvider(
              create: (context) =>
                  AuthBloc(authRepository: authRepository)..add(AppStarted())),
          // BlocProvider(create: (context) => NoteCubit(apiService: apiService)),
        ],
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Unauthenticated) {
              // Use the navigatorKey to navigate
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                RouteNames.login,
                    (route) => false,
              );
            }
          },
          child: MaterialApp(
            navigatorKey: navigatorKey, // Assign the navigator key here
            debugShowCheckedModeBanner: false,
            title: AppConstants.appName,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: ThemeMode.system,
            // initialRoute: RouteNames.notesList,
            home: initialUser == null ? LoginPage() : NotesListPage(),
            // BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
            //   if (state is Authenticated) {
            //     return NotesListPage();
            //   }
            //   return LoginPage();
            // }),
            onGenerateRoute: Routes.generateRoutes,
          ),
        ));
  }
}
