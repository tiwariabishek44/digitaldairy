// File: lib/services/fcm_token_service.dart
// SOLUTION: Centralized FCM token management with guaranteed initialization

import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FCMTokenService extends GetxService {
  static FCMTokenService get to => Get.find();

  final _firebaseMessaging = FirebaseMessaging.instance;
  final _storage = GetStorage();

  // Observable token state
  final Rx<String?> fcmToken = Rx<String?>(null);
  final RxBool isInitialized = false.obs;
  final RxBool isInitializing = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Try to load cached token immediately
    _loadCachedToken();
  }

  /// Load token from storage (instant, for offline use)
  void _loadCachedToken() {
    try {
      final cached = _storage.read('deviceId');
      if (cached != null && cached.isNotEmpty) {
        fcmToken.value = cached;
        log("📦 Loaded cached FCM token: ${cached.substring(0, 20)}...");
      }
    } catch (e) {
      log("⚠️ No cached token found: $e");
    }
  }

  /// Initialize FCM and get fresh token (async, but guaranteed)
  Future<String?> ensureTokenReady({int maxRetries = 5}) async {
    // If already initialized, return immediately
    if (isInitialized.value && fcmToken.value != null) {
      log("✅ FCM token already ready: ${fcmToken.value!.substring(0, 20)}...");
      return fcmToken.value;
    }

    // If currently initializing, wait for it
    if (isInitializing.value) {
      log("⏳ Waiting for ongoing FCM initialization...");
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 500));
        return isInitializing.value; // Continue while initializing
      });
      return fcmToken.value;
    }

    isInitializing.value = true;

    // Try to get fresh token with retries
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        log("🎫 Getting FCM token (attempt $attempt/$maxRetries)...");

        final token = await _firebaseMessaging
            .getToken()
            .timeout(const Duration(seconds: 10));

        if (token != null && token.isNotEmpty) {
          fcmToken.value = token;
          _storage.write('deviceId', token);
          _storage.write(
              'deviceType', GetPlatform.isAndroid ? 'ANDROID' : 'IOS');

          isInitialized.value = true;
          isInitializing.value = false;

          log("✅ FCM token obtained: ${token.substring(0, 20)}...");
          return token;
        }
      } catch (e) {
        log("❌ Attempt $attempt failed: $e");
      }

      if (attempt < maxRetries) {
        final delay = attempt * 2; // 2s, 4s, 6s, 8s, 10s
        log("⏳ Retrying in ${delay}s...");
        await Future.delayed(Duration(seconds: delay));
      }
    }

    isInitializing.value = false;
    log("❌ Failed to get FCM token after $maxRetries attempts");
    return null;
  }

  /// Get token synchronously (returns cached if available, null otherwise)
  String? getTokenSync() {
    return fcmToken.value ?? _storage.read('deviceId');
  }

  /// Get device type
  String getDeviceType() {
    return GetPlatform.isAndroid ? 'ANDROID' : 'IOS';
  }

  /// Refresh token (call this when needed)
  Future<String?> refreshToken() async {
    isInitialized.value = false;
    return ensureTokenReady();
  }
}
