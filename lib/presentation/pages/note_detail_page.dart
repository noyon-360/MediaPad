// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:media_pad/core/constants.dart';
// import 'package:media_pad/core/theme.dart';
// import 'package:media_pad/presentation/bloc/media_pad_note/media_notes_bloc.dart';
// import 'package:media_pad/presentation/bloc/note_bloc/note_bloc_cubit.dart';
//
// class NoteDetailPage extends StatefulWidget {
//   const NoteDetailPage({super.key});
//
//   @override
//   State<NoteDetailPage> createState() => _NoteDetailPageState();
// }
//
// class _NoteDetailPageState extends State<NoteDetailPage> {
//   @override
//   Widget build(BuildContext context) {
//     TextEditingController titleController =
//         TextEditingController(text: 'Note Title');
//     TextEditingController contentController = TextEditingController();
//     print("Note Detail Page");
//     return Scaffold(
//       appBar: AppBar(
//         title: TextField(
//           controller: titleController,
//           textCapitalization: TextCapitalization.sentences,
//           decoration: InputDecoration(
//             hintText: 'Enter note title',
//             border: InputBorder.none,
//           ),
//         ),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 context.read<MediaNotesBloc>().add(AddNoteEvent(
//                     title: titleController.text,
//                     content: contentController.text));
//               },
//               icon: Icon(Icons.check))
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(color: AppThemes.darkTheme.cardColor),
//         height: MediaQuery.of(context).size.height,
//         child: TextField(
//           controller: contentController,
//           decoration: InputDecoration(
//             hintText: 'Enter note content',
//           ),
//           expands: true,
//           maxLines: null,
//         ),
//       ),
//     );
//   }
// }
