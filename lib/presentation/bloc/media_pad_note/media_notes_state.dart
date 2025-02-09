part of 'media_notes_bloc.dart';

abstract class MediaNotesState extends Equatable {
  const MediaNotesState();

  @override
  List<Object> get props => [];
}

class MediaNotesInitial extends MediaNotesState {}

class MediaNotesLoadingState extends MediaNotesState {}

class MediaNotesLoadedState extends MediaNotesState {
  final List<NoteModel> notes;

  const MediaNotesLoadedState({required this.notes});

  @override
  List<Object> get props => [notes];
}

class MediaNotesFilesPickedState extends MediaNotesState {
  final List<File> files;

  const MediaNotesFilesPickedState({required this.files});
  @override
  // TODO: implement props
  List<Object> get props => [files];
}

class MediaNotesErrorState extends MediaNotesState {
  final String message;

  const MediaNotesErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class FileUploadedState extends MediaNotesState {}

// logout
class MediaNotesLogoutState extends MediaNotesState {}
