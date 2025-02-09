import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:media_pad/core/constants.dart';
import 'package:media_pad/data/models/note_model.dart';

class ApiService {
  // static const String baseUrl = AppConstants.baseUrl;
  // final Dio _dio = Dio();
  //
  // // Get Notes
  // Future<List<NoteModel>> getNotes() async {
  //   final response = await _dio.get("$baseUrl/notes");
  //   print("Api is Working");
  //   // print(response.data);
  //   return (response.data as List).map((json) => NoteModel.fromJson(json)).toList();
  //   // return response.data;
  // }

  static const String baseUrl = AppConstants.baseUrl;
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage =
      FlutterSecureStorage(); // Secure storage to get token

  // Get authentication token
  Future<String> _getToken() async {
    final token = await _storage.read(key: AppConstants.tokenKey);
    if (token == null) throw Exception("User is not authenticated.");
    return token;
  }

  // Get Notes with Authentication
  Future<List<NoteModel>> getNotes() async {
    try {
      // final token =
      //     await _storage.read(key: AppConstants.tokenKey); // Retrieve token
      // if (token == null) {
      //   throw Exception("User is not authenticated.");
      // }

      final token = await _getToken();

      final response = await _dio.get(
        "$baseUrl/notes",
        options:
            Options(headers: {"Authorization": token}), // Add token to request
      );

      print("API Response: ${response.data}");
      return (response.data as List)
          .map((json) => NoteModel.fromJson(json))
          .toList();
    } catch (error) {
      print("Error fetching notes: $error");
      throw Exception("Failed to fetch notes.");
    }
  }

  // Add a new note
  Future<void> addNote(String title, String content, List<File>? files) async {
    try {
      // final token = await _storage.read(key: AppConstants.tokenKey);
      // if (token == null) throw Exception("User not authenticated.");

      final token = await _getToken();

      FormData formData = FormData.fromMap({
        'title': title,
        'content': content,
      });

      if (files != null && files.isNotEmpty) {
        for (var file in files) {
          if (kIsWeb) {
            final fileBytes = await file.readAsBytes();
            formData.files.add(MapEntry(
              'files',
              MultipartFile.fromBytes(fileBytes,
                  filename: file.path.split('/').last),
            ));
          } else {
            formData.files.add(MapEntry(
              'files',
              MultipartFile.fromFileSync(file.path,
                  filename: file.path.split('/').last),
            ));
          }
        }
      }

      Response response = await _dio.post(
        "$baseUrl/add-note",
        options: Options(headers: {"Authorization": token}),
        data: formData,
      );

      if (response.statusCode == 201) {
        print("Note added successfully: ${response.data}");
      } else {
        print("Failed to add note: ${response.statusMessage}");
      }
    } catch (error) {
      throw Exception("Failed to add note: $error");
    }
  }

  // Web Add note with files
  Future<void> webAddNote(
      String title, String content, List<PlatformFile>? files) async {
    try {
      // final token = await _storage.read(key: AppConstants.tokenKey);
      // if (token == null) throw Exception("User not authenticated.");

      final token = await _getToken();

      FormData formData = FormData.fromMap({
        'title': title,
        'content': content,
      });

      if (files != null && files.isNotEmpty) {
        for (var file in files) {
          formData.files.add(MapEntry(
            'files',
            MultipartFile.fromBytes(file.bytes!, filename: file.name),
          ));
        }
      }

      Response response = await _dio.post(
        "$baseUrl/add-note",
        options: Options(headers: {"Authorization": token}),
        data: formData,
      );

      if (response.statusCode == 201) {
        print("Note added successfully: ${response.data}");
      } else {
        print("Failed to add note: ${response.statusMessage}");
      }
    } catch (error) {
      throw Exception("Failed to add note: $error");
    }
  }

  // **Edit Note**
  Future<void> editNote(String noteId, String title, String content) async {
    try {
      final token = await _getToken();
      await _dio.put(
        "$baseUrl/edit-note/$noteId",
        options: Options(headers: {"Authorization": token}),
        data: {"title": title, "content": content},
      );
    } catch (error) {
      throw Exception("Failed to edit note: $error");
    }
  }

  // **Delete Note**
  Future<void> deleteNote(String noteId) async {
    try {
      final token = await _getToken();
      await _dio.delete(
        "$baseUrl/delete-note/$noteId",
        options: Options(headers: {"Authorization": token}),
      );
    } catch (error) {
      throw Exception("Failed to delete note: $error");
    }
  }
}
