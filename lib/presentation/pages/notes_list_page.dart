import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:media_pad/config/route/routes_name.dart';
import 'package:media_pad/core/constants.dart';
import 'package:media_pad/data/models/note_model.dart';
import 'package:media_pad/presentation/bloc/Authentication/auth_bloc.dart';
import 'package:media_pad/presentation/bloc/media_pad_note/media_notes_bloc.dart';
import 'package:media_pad/presentation/pages/note_form_page.dart';

class NotesListPage extends StatefulWidget {
  const NotesListPage({super.key});

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  int? _selectedNoteIndex;
  bool _showDetails = false; // Add this line

  // List<File> _selectedFiles = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _titleController.clear();
    _contentController.clear();
    _selectedNoteIndex = null;
  }

  void _loadNoteIntoForm(NoteModel note) {
    _titleController.text = note.title;
    _contentController.text = note.content;
  }

  // Future<void> _pickFiles() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     allowMultiple: true,
  //     type: FileType.any,
  //   );
  //
  //   print("File picker");
  //   print(result);
  //
  //   if (result != null) {
  //     setState(() {
  //       _selectedFiles = result.paths.map((path) => File(path!)).toList();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    print(MediaQuery.of(context).size.width);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocBuilder<MediaNotesBloc, MediaNotesState>(
        builder: (context, state) {
          if (state is MediaNotesLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MediaNotesLoadedState) {
            return _buildNotesLayout(state, isWeb);
          }
          // else if(state is MediaNotesFilesPickedState){
          //   return _buildNotesLayout(state as MediaNotesLoadedState, isWeb);
          // }
          return Center(
            child: Text("No notes found"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          if (isWeb) {
            // For web, show the form inline
            setState(() {
              _selectedNoteIndex = null;
              _clearForm();
            });
          } else {
            // For mobile, open the form in a full-screen dialog
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteFormPage(),
              ),
            );
          }
        },
      ),
      floatingActionButtonLocation: isWeb
          ? FloatingActionButtonLocation.startFloat
          : FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildNotesLayout(MediaNotesLoadedState state, bool isWeb) {
    if (isWeb) {
      return Row(
        children: [
          // Left Side: Notes List
          SizedBox(
            width: 300, // Fixed width for the notes list
            child: ListView.builder(
              itemCount: state.notes.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final note = state.notes[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedNoteIndex = index;
                      _loadNoteIntoForm(note);
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _selectedNoteIndex == index
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1)
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                      border: _selectedNoteIndex == index
                          ? Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            )
                          : null,
                    ),
                    child: ListTile(
                      title: Text(note.title),
                      subtitle: Text(note.content),
                      // trailing: IconButton(
                      //     onPressed: () {
                      //       final noteId = note.id;
                      //       context
                      //           .read<MediaNotesBloc>()
                      //           .add(DeleteNoteEvent(noteId: noteId));
                      //     },
                      //     icon: Icon(
                      //       Icons.delete,
                      //       color: Colors.red,
                      //     )),
                    ),
                  ),
                );
              },
            ),
          ),

          // Right Side: Add/Edit Note Form and Details
          Expanded(
            flex: _showDetails && MediaQuery.of(context).size.width < 1000
                ? 1
                : 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: _showDetails &&
                            MediaQuery.of(context).size.width < 1000
                        ? const SizedBox
                            .shrink() // Hide form when details are shown on small screens
                        : _buildNoteForm(state),
                  ),
                ],
              ),
            ),
          ),
          // Details Section (only shown when _showDetails is true)
          if (_showDetails && _selectedNoteIndex != null)
            Expanded(
              flex: MediaQuery.of(context).size.width < 1000 ? 2 : 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: _buildNoteDetails(state.notes[_selectedNoteIndex!]),
                ),
              ),
            ),
        ],
      );
    } else {
      // Mobile Layout
      return BlocBuilder<MediaNotesBloc, MediaNotesState>(
        builder: (context, states) {
          return ListView.builder(
            itemCount: state.notes.length,
            itemBuilder: (context, index) {
              final note = state.notes[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NoteFormPage(
                                note: note,
                              )));
                },
                child: Dismissible(
                  key: Key(note.id),
                  onDismissed: (direction) {
                    setState(() {
                      // Remove the note from the local list immediately
                      state.notes.removeAt(index);
                    });

                    final noteId = note.id;
                    context
                        .read<MediaNotesBloc>()
                        .add(DeleteNoteEvent(noteId: noteId));

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Item deleted")),
                    );
                  },
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  // ... rest of dismissible code
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        note.title,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        note.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    }
  }

  // Add new _buildNoteDetails method
  Widget _buildNoteDetails(NoteModel note) {
    return Card(
      // margin: const EdgeInsets.only(top: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Note Details",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => _showDetails = false),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailItem("Title", note.title),
            _buildDetailItem("Content", note.content),
            _buildDetailItem(
              "Last Updated",
              DateFormat.yMMMd().add_jm().format(note.updatedAt),
            ),
            if (note.files.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                "Attachments:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ...note.files.map((file) => ListTile(
                    leading: const Icon(Icons.attach_file),
                    title: Text(file.fileName),
                  )),
            ],
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    // This is for the note delete
                    onPressed: () {
                      _clearForm();
                      final noteId = note.id;
                      context
                          .read<MediaNotesBloc>()
                          .add(DeleteNoteEvent(noteId: noteId));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                    child: Text("Delete"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Add _buildDetailItem helper method
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // void _showNoteDetails(BuildContext context, NoteModel note) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text("Note Details"),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text("Title: ${note.title}"),
  //           Text("Content: ${note.content}"),
  //           const SizedBox(height: 16),
  //           Text(
  //               "Last Updated: ${DateFormat.yMMMd().add_jm().format(note.updatedAt)}"),
  //           if (note.files.isNotEmpty) ...[
  //             const SizedBox(height: 16),
  //             const Text("Attachments:",
  //                 style: TextStyle(fontWeight: FontWeight.bold)),
  //             ...note.files.map((file) => Text(file.fileName)),
  //           ],
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text("Close"),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildNoteForm(MediaNotesLoadedState state) {
    return SingleChildScrollView(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedNoteIndex != null ? "Edit Note" : "Add Note",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_selectedNoteIndex != null)
                    IconButton(
                        icon: Icon(
                          _showDetails ? Icons.info : Icons.info_outline,
                          color: _showDetails
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                        onPressed: () {
                          setState(() => _showDetails = true);
                          // _showNoteDetails( context,
                          //   state.notes[_selectedNoteIndex!],
                          // );
                        }),
                ],
              ),
              SizedBox(height: 16),
              Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      labelText: 'Content',
                      border: OutlineInputBorder(),
                    ),
                    // maxLines: 5,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MediaNotesBloc>().add(PickFilesEvent());
                    },
                    child: Icon(Icons.attach_file),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        //Add note or Edit note
                        if (_titleController.text.isEmpty ||
                            _contentController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text("Title and content cannot be empty"),
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ),
                          );
                          return;
                        }

                        if (_selectedNoteIndex != null) {
                          // Update existing note
                          final noteId = state.notes[_selectedNoteIndex!].id;

                          print("NoteId : $noteId");

                          context.read<MediaNotesBloc>().add(EditNoteEvent(
                                noteId: noteId,
                                title: _titleController.text,
                                content: _contentController.text,
                              ));
                        } else {
                          // Add new note
                          // final newNote = NoteModel(
                          //   id: DateTime.now().toString(), // Generate unique ID
                          //   title: _titleController.text,
                          //   content: _contentController.text,
                          //   updatedAt: DateTime.now(),
                          //   files: List.empty()
                          // );

                          // print(_selectedFiles);

                          context.read<MediaNotesBloc>().add(AddNoteEvent(
                                title: _titleController.text,
                                content: _contentController.text,
                              ));
                        }

                        // _clearForm();
                      },
                      child: Text(_selectedNoteIndex != null
                          ? "Update Note"
                          : "Add Note"),
                    ),
                  ),
                  if (_selectedNoteIndex != null) ...[
                    SizedBox(width: 16),
                    ElevatedButton(
                      // This is for the note clear when edit
                      onPressed: () {
                        _clearForm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                      child: Text("Cancel"),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
