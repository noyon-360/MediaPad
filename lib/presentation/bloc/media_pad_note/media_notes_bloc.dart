import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:media_pad/data/api/auth_repository.dart';
import 'package:media_pad/data/api/note_services.dart';
import 'package:media_pad/data/models/note_model.dart';
import 'package:media_pad/presentation/bloc/Authentication/auth_bloc.dart';

part 'media_notes_event.dart';

part 'media_notes_state.dart';

class MediaNotesBloc extends Bloc<MediaNotesEvent, MediaNotesState> {
  final ApiService apiService;

  List<File>? selectedFiles;
  List<PlatformFile>? selectedWebFiles;

  final _noteController = StreamController<List<NoteModel>>.broadcast();

  Stream<List<NoteModel>> get noteSteam => _noteController.stream;

  MediaNotesBloc({required this.apiService}) : super(MediaNotesInitial()) {
    on<LoadNotesEvent>(_loadNotesEvent);
    on<AddNoteEvent>(_addNoteEvent);
    on<PickFilesEvent>(_pickFilesEvent);
    on<EditNoteEvent>(_editNoteEvent);
    on<DeleteNoteEvent>(_deleteNoteEvent);
  }

  // Load Notes
  Future<void> _loadNotesEvent(
      LoadNotesEvent event, Emitter<MediaNotesState> emit) async {
    emit(MediaNotesLoadingState());
    try {
      print("Im in the bloc");
      final notes = await apiService.getNotes();
      print(notes.map((e) => e.title).toList());
      _noteController.add(notes);
      emit(MediaNotesLoadedState(notes: notes));
    } catch (e) {
      emit(MediaNotesErrorState(message: e.toString()));
    }
  }

  // Add Note
  Future<void> _addNoteEvent(
      AddNoteEvent event, Emitter<MediaNotesState> emit) async {
    try {
      emit(MediaNotesLoadingState());
      print("this is add note bloc");
      print(selectedFiles);
      if (kIsWeb) {
        await apiService.webAddNote(event.title, event.content, selectedWebFiles);
        selectedWebFiles = null;
      } else {
        await apiService.addNote(event.title, event.content, selectedFiles);
        selectedFiles = null;
      }
      final notes = await apiService.getNotes();
      print("Check the response of add note api ${notes.map((e) => e.title)}");
      _noteController.add(notes);
      emit(MediaNotesLoadedState(notes: notes));
    } catch (e) {
      emit(MediaNotesErrorState(message: e.toString()));
    }
  }

  Future<void> _pickFilesEvent(
      PickFilesEvent event, Emitter<MediaNotesState> emit) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );
      // print(result!.files);

      if (result != null) {
        if (kIsWeb) {
          //     // For web: Create File objects from bytes
          selectedWebFiles = result.files.map((file) => file).toList();
        } else {
          selectedFiles = result.paths.map((path) => File(path!)).toList();
        }
        // Todo : When file uploading it make problem in web or big screens
        print("File pick for web");
        print(selectedFiles);
        //
        // }
        //   emit(MediaNotesFilesPickedState(files: selectedFiles!));
      } else {
        emit(MediaNotesErrorState(message: "No files selected"));
      }
    } catch (e) {
      emit(MediaNotesErrorState(message: "Filed to pick files: $e"));
    }
  }

  // **Edit Note**
  Future<void> _editNoteEvent(
      EditNoteEvent event, Emitter<MediaNotesState> emit) async {
    try {
      await apiService.editNote(event.noteId, event.title, event.content);
      final notes = await apiService.getNotes();
      _noteController.add(notes);
      emit(MediaNotesLoadedState(notes: notes));
    } catch (e) {
      emit(MediaNotesErrorState(message: e.toString()));
    }
  }

  // Delete Note
  Future<void> _deleteNoteEvent(
      DeleteNoteEvent event, Emitter<MediaNotesState> emit) async {
    try {
      await apiService.deleteNote(event.noteId);
      final notes = await apiService.getNotes();
      _noteController.add(notes);
      emit(MediaNotesLoadedState(notes: notes));
    } catch (e) {
      emit(MediaNotesErrorState(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _noteController.close();
    return super.close();
  }
}
