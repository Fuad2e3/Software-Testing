import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  const ApiService();

  static final String _baseUrl = _getBaseUrl();

  static String _getBaseUrl() {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    }
    return 'http://10.0.2.2:3000/api';
  }

  static final Dio _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  static const _storage = FlutterSecureStorage();

  // ── REGISTER ──
  Future<Map<String, dynamic>> register(
    String name, String email, String password
  ) async {
    try {
      final res = await _dio.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      return res.data;
    } catch (e) {
      String message = 'Something went wrong!';
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout) {
          message = 'Connection timeout. Is the server running?';
        } else if (e.type == DioExceptionType.connectionError) {
          message = 'Connection error. Check your network or server.';
        } else if (e.response != null && e.response!.data is Map) {
          message = e.response!.data['message'] ?? message;
        }
      }
      return {'success': false, 'message': message};
    }
  }

  // ── LOGIN ──
  Future<Map<String, dynamic>> login(
    String email, String password
  ) async {
    try {
      final res = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      // Token save করো
      if (res.data['token'] != null) {
        await _storage.write(key: 'token', value: res.data['token']);
      }

      return res.data;
    } catch (e) {
      String message = 'Login failed!';
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout) {
          message = 'Connection timeout. Is the server running?';
        } else if (e.type == DioExceptionType.connectionError) {
          message = 'Connection error. Check your network or server.';
        } else if (e.response != null && e.response!.data is Map) {
          message = e.response!.data['message'] ?? message;
        } else if (e.response?.statusCode == 429) {
          message = 'Too many attempts! Try again later.';
        }
      }
      return {'success': false, 'message': message};
    }
  }

  // ── LOGOUT ──
  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }

  // ── Token পড়ো ──
  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }
}
