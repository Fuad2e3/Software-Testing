import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  const ApiService();

  // Emulator এ localhost = 10.0.2.2
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:3000/api',
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
      return {'success': false, 'message': 'Something went wrong!'};
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
      return {'success': false, 'message': 'Login failed!'};
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
