// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:media_pad/data/api/note_services.dart';
// import 'package:media_pad/data/models/note_model.dart';
//
// class NoteCubit extends Cubit<List<NoteModel>> {
//   final ApiService apiService;
//
//   NoteCubit({required this.apiService}) : super([]);
//
//   // Fetch Notes
//   Future<void> fetchNotes() async {
//     try {
//       final notes = await apiService.getNotes();
//       emit(notes);
//     } catch (error) {
//       emit([]);
//     }
//   }
//
//
//   // Add Note
//   Future<void> addNote(String title, String content) async {
//     try {
//       await apiService.addNote(title, content);
//       // fetchNotes(); // Refresh notes after adding
//     } catch (error) {
//       print("Error adding note: $error");
//     }
//   }
// }
