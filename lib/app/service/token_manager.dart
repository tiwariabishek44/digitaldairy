import 'dart:async';
import 'dart:io';

import 'package:digitaldairy/app/config/api_end_point.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import 'dart:developer';
import 'session_service.dart';

class TokenManager {
  final SessionService _sessionService = SessionService();
  static const String _refreshEndpoint = ApiEndPoints.register;
  bool _isLoggingOut = false; // Prevent multiple logout calls

  // Check if the access token is valid and not expired
  Future<bool> isAccessTokenValid() async {
    final accessToken = _sessionService.accessToken;
    if (accessToken == null || accessToken.isEmpty) return false;
    try {
      return !JwtDecoder.isExpired(accessToken);
    } catch (e) {
      return false;
    }
  }

  // Check if the refresh token is valid and not expired
  bool isRefreshTokenValid() {
    final refreshToken = _sessionService.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) return false;
    try {
      return !JwtDecoder.isExpired(refreshToken);
    } catch (e) {
      return false;
    }
  }

  // Get a valid access token, refresh if needed
  Future<String?> getValidAccessToken() async {
    log("🔍 Checking access token validity...");
    if (await isAccessTokenValid()) {
      log("✅ Access token is valid");
      return _sessionService.accessToken;
    }

    // Try to refresh the token
    final refreshed = await _refreshToken();
    if (refreshed) {
      return _sessionService.accessToken;
    }
    return null;
  }

  // Refresh the access token using the refresh token
  Future<bool> _refreshToken() async {
    if (_isLoggingOut) return false; // Avoid redundant logout attempts

    final refreshToken = _sessionService.refreshToken;
    if (refreshToken == null || !isRefreshTokenValid()) {
      await _logout();
      return false;
    }

    try {
      final response = await http
          .post(
            Uri.parse(_refreshEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'refreshToken': refreshToken}),
          )
          .timeout(const Duration(seconds: 10)); // Timeout to avoid hanging

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          await _sessionService.saveTokens(
            accessToken: data['data']['accessToken'],
            refreshToken: data['data']['refreshToken'],
          );
          log("✅ Token refreshed successfully");
          return true;
        }
      }
      await _logout();
      return false;
    } on SocketException {
      log("❌ Refresh token failed: No network connection");

      return false;
    } on TimeoutException {
      log("❌ Refresh token failed: Request timed out");
      // await _logout();
      return false;
    } catch (e) {
      log("❌ Refresh token failed: $e");
      // await _logout();
      return false;
    }
  }

  // Logout and clear all session data
  Future<void> _logout() async {
    if (!_isLoggingOut) {
      _isLoggingOut = true;
      await _sessionService.clearAll();
      log("🗑️ All session data cleared");
    }
  }
}
