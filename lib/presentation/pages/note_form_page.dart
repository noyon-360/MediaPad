import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:media_pad/data/models/note_model.dart';
import 'package:media_pad/presentation/bloc/media_pad_note/media_notes_bloc.dart';

class NoteFormPage extends StatelessWidget {
  final NoteModel? note;

  const NoteFormPage({this.note, super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: note?.title);
    final contentController = TextEditingController(text: note?.content);


    return Scaffold(
      appBar: AppBar(
        title: Text(note != null ? "Edit Note" : "Add Note"),
        actions: [
          if (note != null)
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteDetailsPage(note: note!),
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),

            // file picker
            ElevatedButton(
              onPressed: () {
                context.read<MediaNotesBloc>().add(PickFilesEvent());
              },
              child: Icon(Icons.attach_file),
            ),

            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      if (titleController.text.isEmpty || contentController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Title and content cannot be empty"),
                            backgroundColor: Theme.of(context).colorScheme.error,
                          ),
                        );
                        return;
                      }

                      if (note != null) {
                        // Update existing note
                        // final updatedNote = note!.copyWith(
                        //   title: _titleController.text,
                        //   content: _contentController.text,
                        //   updatedAt: DateTime.now(),
                        // );
                        final noteId = note!.id;

                        print(noteId);

                        context.read<MediaNotesBloc>().add(EditNoteEvent(noteId: noteId, title: titleController.text, content: contentController.text));
                      } else {
                        // Add new note
                        // final newNote = NoteModel(
                        //   id: DateTime.now().toString(), // Generate unique ID
                        //   title: _titleController.text,
                        //   content: _contentController.text,
                        //   updatedAt: DateTime.now(),
                        // );
                        context.read<MediaNotesBloc>().add(AddNoteEvent(title: titleController.text, content: contentController.text));
                      }

                      Navigator.pop(context); // Close the form after saving
                    },
                    child: Text(note != null ? "Update Note" : "Add Note"),
                  ),
                ),

                // const Spacer(),
                SizedBox(width: 10,),

                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                      onPressed: (){
                        context.read<MediaNotesBloc>().add(DeleteNoteEvent(noteId: note!.id));
                      }, child: Text("Delete", style: TextStyle(color: Colors.white),)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Add new NoteDetailsPage
class NoteDetailsPage extends StatelessWidget {
  final NoteModel note;

  const NoteDetailsPage({required this.note, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Note Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailItem("Title", note.title),
            _buildDetailItem("Content", note.content),
            _buildDetailItem(
              "Last Updated",
              DateFormat.yMMMd().add_jm().format(note.updatedAt),
            ),
            if (note.files.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Attachments:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ...note.files.map((file) => ListTile(
                leading: const Icon(Icons.attach_file),
                title: Text(file.fileName),
              )),
            ],
          ],
        ),
      ),
    );
  }

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
}