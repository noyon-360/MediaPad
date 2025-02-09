part of 'media_notes_bloc.dart';

abstract class MediaNotesEvent extends Equatable {
  const MediaNotesEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

// Load Notes
class LoadNotesEvent extends MediaNotesEvent {}

class AddNoteEvent extends MediaNotesEvent {
  final String title;
  final String content;
  final List<File>? files;

  const AddNoteEvent({required this.title, required this.content, this.files});

  @override
  // TODO: implement props
  List<Object?> get props => [title, content];
}

class PickFilesEvent extends MediaNotesEvent {}

// Edit Note Event
class EditNoteEvent extends MediaNotesEvent {
  final String noteId;
  final String title;
  final String content;

  const EditNoteEvent({required this.noteId, required this.title, required this.content});

  @override
  List<Object> get props => [noteId, title, content];
}

class DeleteNoteEvent extends MediaNotesEvent {
  final String noteId;

  const DeleteNoteEvent({required this.noteId});

  @override
  // TODO: implement props
  List<Object?> get props => [noteId];
}
