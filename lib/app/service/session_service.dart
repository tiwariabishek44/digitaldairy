import 'dart:convert';
import 'dart:developer';
import 'package:get_storage/get_storage.dart';

//-----------------------SESSION SERVICE (Token Storage)-----------------------
class SessionService {
  static final SessionService _instance = SessionService._internal();
  factory SessionService() => _instance;
  SessionService._internal();

  final GetStorage _storage = GetStorage();

  // Token keys
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';
  static const String _userDataKey = 'userData';
  static const String _isLoggedInKey = 'isLoggedIn';

  //-----------------------SAVE TOKENS-----------------------
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(_accessTokenKey, accessToken);
    await _storage.write(_refreshTokenKey, refreshToken);
    await _storage.write(_isLoggedInKey, true);
    log("✅ Tokens saved successfully");
  }

  //-----------------------GET TOKENS-----------------------
  String? get accessToken => _storage.read(_accessTokenKey);
  String? get refreshToken => _storage.read(_refreshTokenKey);
  bool get isLoggedIn => _storage.read(_isLoggedInKey) ?? false;

  //-----------------------SAVE USER DATA-----------------------
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _storage.write(_userDataKey, jsonEncode(userData));
    log("✅ User data saved");
  }

  //-----------------------GET USER DATA-----------------------
  Map<String, dynamic>? get userData {
    final userDataString = _storage.read(_userDataKey);
    if (userDataString != null) {
      return jsonDecode(userDataString) as Map<String, dynamic>;
    }
    return null;
  }

  //-----------------------CLEAR ALL DATA-----------------------
  Future<void> clearAll() async {
    await _storage.remove(_accessTokenKey);
    await _storage.remove(_refreshTokenKey);
    await _storage.remove(_userDataKey);
    await _storage.remove(_isLoggedInKey);
    log("🗑️ All session data cleared");
  }

  //-----------------------CHECK TOKEN VALIDITY-----------------------
  bool get hasValidTokens {
    return accessToken != null &&
        refreshToken != null &&
        accessToken!.isNotEmpty &&
        refreshToken!.isNotEmpty;
  }
}
