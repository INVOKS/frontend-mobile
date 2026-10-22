import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

// ─── Konfigurasi URL Dinamis ─────────────────────────────────────────────────
// - Flutter Web / Windows / macOS / iOS: http://localhost:5000/api
// - Android Emulator: http://10.0.2.2:5000/api (alias localhost host machine)
String get _baseUrl {
  if (kIsWeb) {
    final host = Uri.base.host.isNotEmpty ? Uri.base.host : 'localhost';
    return 'http://$host:5000/api';
  }
  if (defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2:5000/api';
  }
  return 'http://localhost:5000/api';
}

const _keyToken = 'invoks_token';
const _keyUser = 'invoks_user';

// ─── Model Response ──────────────────────────────────────────────────────────
class AuthResult {
  final bool success;
  final String message;
  final String? token;
  final AuthUser? user;
  final Map<String, String>? errors;

  const AuthResult({
    required this.success,
    required this.message,
    this.token,
    this.user,
    this.errors,
  });
}

class AuthUser {
  final int id;
  final String namaLengkap;
  final String email;
  final String role;
  final String? gender;
  final String? jurusan;
  final String? noTelp;
  final String? foto;

  const AuthUser({
    required this.id,
    required this.namaLengkap,
    required this.email,
    required this.role,
    this.gender,
    this.jurusan,
    this.noTelp,
    this.foto,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: (json['id'] as num).toInt(),
      namaLengkap: json['namaLengkap'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      gender: json['gender'] as String?,
      jurusan: json['jurusan'] as String?,
      noTelp: json['noTelp'] as String?,
      foto: json['foto'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'namaLengkap': namaLengkap,
        'email': email,
        'role': role,
        'gender': gender,
        'jurusan': jurusan,
        'noTelp': noTelp,
        'foto': foto,
      };

  UserProfile toUserProfile() => UserProfile(
        name: namaLengkap,
        email: email,
        gender: gender == 'laki_laki'
            ? 'Laki Laki'
            : (gender == 'perempuan' ? 'Perempuan' : null),
        major: jurusan,
        phone: noTelp,
      );
}

// ─── Auth Service ─────────────────────────────────────────────────────────────
class AuthService {
  // Singleton
  AuthService._();
  static final AuthService instance = AuthService._();

  // ── Session management ──────────────────────────────────────────────────────
  Future<void> saveSession(String token, AuthUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyUser, jsonEncode(user.toJson()));
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  Future<AuthUser?> getStoredUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyUser);
    if (raw == null) return null;
    try {
      return AuthUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUser);
  }

  // ── API calls ───────────────────────────────────────────────────────────────
  Map<String, String> get _jsonHeaders => const {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      };

  Map<String, String> _authHeaders(String token) => {
        ..._jsonHeaders,
        'Authorization': 'Bearer $token',
      };

  /// Login pengguna biasa (role: user)
  Future<AuthResult> loginUser({
    required String email,
    required String password,
    bool ingatSaya = false,
  }) async {
    return _doLogin(
      endpoint: '$_baseUrl/auth/login',
      email: email,
      password: password,
      ingatSaya: ingatSaya,
    );
  }

  /// Login admin (role: admin)
  Future<AuthResult> loginAdmin({
    required String email,
    required String password,
    bool ingatSaya = false,
  }) async {
    return _doLogin(
      endpoint: '$_baseUrl/auth/admin/login',
      email: email,
      password: password,
      ingatSaya: ingatSaya,
    );
  }

  Future<AuthResult> _doLogin({
    required String endpoint,
    required String email,
    required String password,
    required bool ingatSaya,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(endpoint),
            headers: _jsonHeaders,
            body: jsonEncode({
              'email': email.trim().toLowerCase(),
              'password': password,
              'ingatSaya': ingatSaya,
            }),
          )
          .timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final success = body['success'] as bool? ?? false;
      final message = body['message'] as String? ?? 'Terjadi kesalahan';

      if (success && response.statusCode == 200) {
        final data = body['data'] as Map<String, dynamic>?;
        final token = data?['token'] as String?;
        final userJson = data?['user'] as Map<String, dynamic>?;

        if (token != null && userJson != null) {
          final user = AuthUser.fromJson(userJson);
          await saveSession(token, user);
          return AuthResult(
              success: true, message: message, token: token, user: user);
        }
      }

      // Handle validation errors
      final errors = (body['errors'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v.toString()));

      return AuthResult(success: false, message: message, errors: errors);
    } on TimeoutException {
      return const AuthResult(
        success: false,
        message:
            'Koneksi waktu habis (timeout). Pastikan backend INVOKS aktif di port 5000.',
      );
    } on http.ClientException catch (e) {
      return AuthResult(
          success: false, message: 'Kesalahan jaringan: ${e.message}');
    } catch (e) {
      return AuthResult(
        success: false,
        message:
            'Tidak dapat terhubung ke server. Pastikan backend INVOKS sedang berjalan.',
      );
    }
  }

  /// Register pengguna baru
  Future<AuthResult> register({
    required String namaLengkap,
    required String email,
    required String password,
    required String konfirmasiPassword,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/auth/register'),
            headers: _jsonHeaders,
            body: jsonEncode({
              'namaLengkap': namaLengkap.trim(),
              'email': email.trim().toLowerCase(),
              'password': password,
              'konfirmasiPassword': konfirmasiPassword,
            }),
          )
          .timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final success = body['success'] as bool? ?? false;
      final message = body['message'] as String? ?? 'Terjadi kesalahan';

      // Handle validation errors
      final errors = (body['errors'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v.toString()));

      return AuthResult(success: success, message: message, errors: errors);
    } on TimeoutException {
      return const AuthResult(
        success: false,
        message:
            'Koneksi waktu habis (timeout). Pastikan backend INVOKS aktif di port 5000.',
      );
    } on http.ClientException catch (e) {
      return AuthResult(
          success: false, message: 'Kesalahan jaringan: ${e.message}');
    } catch (e) {
      return const AuthResult(
        success: false,
        message:
            'Tidak dapat terhubung ke server. Pastikan backend INVOKS sedang berjalan.',
      );
    }
  }

  /// Ambil profil pengguna yang sedang login
  Future<AuthResult> getProfile() async {
    final token = await getToken();
    if (token == null) {
      return const AuthResult(success: false, message: 'Sesi tidak ditemukan');
    }

    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/auth/me'), headers: _authHeaders(token))
          .timeout(const Duration(seconds: 10));

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final success = body['success'] as bool? ?? false;
      final message = body['message'] as String? ?? '';

      if (success) {
        final data = body['data'] as Map<String, dynamic>?;
        final userJson = data?['user'] as Map<String, dynamic>?;
        if (userJson != null) {
          final user = AuthUser.fromJson(userJson);
          // Update cache
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_keyUser, jsonEncode(user.toJson()));
          return AuthResult(success: true, message: message, user: user);
        }
      }
      return AuthResult(success: false, message: message);
    } on TimeoutException {
      return const AuthResult(
          success: false, message: 'Koneksi waktu habis (timeout)');
    } catch (e) {
      return AuthResult(success: false, message: 'Kesalahan: $e');
    }
  }

  /// Logout — hapus sesi lokal
  Future<void> logout() async {
    await clearSession();
  }
}
