import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:media_pad/core/constants.dart';
import 'package:media_pad/core/exceptions/dio_exception.dart';
import 'package:media_pad/data/models/user_model.dart';

class AuthRepository {
  final String baseUrl = AppConstants.baseUrl;
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final Dio _dio = Dio();

  AuthRepository() {
    _dio.options.baseUrl = baseUrl;
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      final token = await _storage.read(key: AppConstants.tokenKey);
      if (token != null) {
        options.headers['Authorization'] = token;
      }
      return handler.next(options);
    }, onError: (error, handler) async {
      if (error.response?.statusCode == 401) {
        await logout();
      }

      return handler.next(error);
    }));
  }

  Future<bool> isAuthenticated() async {
    try {
      final token = await _storage.read(key: AppConstants.tokenKey);
      if (token == null) return false; // No token means not authenticated

      final response = await _dio.post('$baseUrl/auth/checkValidation');

      if (response.statusCode == 200 && response.data['success'] == true) {
        return true; // User is authenticated
      } else {
        return false; // Unauthorized
      }
    } catch (e) {
      return false; // Any error means authentication failed
    }
  }

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _dio.post('$baseUrl/auth/login', data: {
        'email': email,
        'password': password,
      });

      // Directly parse the response data
      final user = UserModel.fromJson(response.data);
      print(user);
      await _saveUserData(user);
      return user;
    } on DioException catch (dioError) {
      final errorMessage = dioError.response?.data['message'] ??
          'An error occurred during login';
      throw DioExceptionMessage(errorMessage);
    }
  }

  Future<void> register(String name, String email, String password,
      String confirmPassword) async {
    try {
      await _dio.post('$baseUrl/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword
      });

      // // Directly parse the response data
      // final user = UserModel.fromJson(response.data);
      // await _saveUserData(user);
      // return user;
    } on DioException catch (dioError) {
      final errorMessage = dioError.response?.data['message'] ??
          'An error occurred during register';
      throw DioExceptionMessage(errorMessage);
    }
  }

  // Save user data
  Future<void> _saveUserData(UserModel user) async {
    print(user.token);
    await _storage.write(key: AppConstants.tokenKey, value: user.token);
    await _storage.write(
        key: AppConstants.userKey, value: jsonEncode(user.toJson()));
  }

  // Get user data
  Future<UserModel?> getUser() async {
    final userJson = await _storage.read(key: AppConstants.userKey);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<void> logout() async {
    await _storage.delete(key: AppConstants.tokenKey);
    await _storage.delete(key: AppConstants.userKey);
  }
}
