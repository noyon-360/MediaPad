import 'package:flutter/material.dart';
import 'package:media_pad/config/route/routes_name.dart';
import 'package:media_pad/presentation/pages/AuthScreens/login_page.dart';
import 'package:media_pad/presentation/pages/AuthScreens/register_page.dart';
import 'package:media_pad/presentation/pages/note_detail_page.dart';
import 'package:media_pad/presentation/pages/notes_list_page.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.notesList:
        return MaterialPageRoute(builder: (context) => NotesListPage());

      case RouteNames.login:
        return MaterialPageRoute(builder: (context) => LoginPage());

      case RouteNames.register:
        return MaterialPageRoute(builder: (context) => RegisterPage());

      // case RouteNames.noteDetail:
      //   return MaterialPageRoute(builder: (context) => NoteDetailPage());
      default:
        return MaterialPageRoute(builder: (context) => NotesListPage());
    }
  }
}
