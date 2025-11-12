// File: lib/app/modules/login/login_controller.dart
// Updated with reliable device registration

import 'dart:developer';
import 'package:digitaldairy/app/model/login_response.dart';
import 'package:digitaldairy/app/modules/login/login_view.dart';
import 'package:digitaldairy/app/modules/register/register_view.dart';
import 'package:digitaldairy/app/repository/login_repository.dart';
import 'package:digitaldairy/app/service/api_client.dart';
import 'package:digitaldairy/app/widget/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  // Form controllers
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  // Repository
  final LoginRepository _loginRepository = LoginRepository();

  // Storage
  final _storage = GetStorage();

  // Observable variables
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var currentUser = Rx<LoginData?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadCachedUserData();
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // ============================================================================
  // UI METHODS
  // ============================================================================

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void goToRegister() {
    Get.to(() => RegisterView());
  }

  void forgotPassword() {
    GajuriSnackbar.showInfo(
      title: 'जानकारी',
      message: 'पासवर्ड रिसेट फिचर छिट्टै आउँदैछ',
      duration: Duration(seconds: 3),
    );
  }

  // ============================================================================
  // VALIDATION METHODS
  // ============================================================================

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'कृपया फोन नम्बर लेख्नुहोस्';
    }
    if (value.length < 10) {
      return 'सही फोन नम्बर लेख्नुहोस्';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'कृपया पासवर्ड लेख्नुहोस्';
    }
    return null;
  }

  // ============================================================================
  // LOCAL STORAGE METHODS
  // ============================================================================

  /// Save user data to local storage
  Future<void> _saveUserDataLocally(LoginData userData) async {
    try {
      // Save user data
      await _storage.write('user_data', userData.toJson());
      await _storage.write('access_token', userData.accessToken);
      await _storage.write('refresh_token', userData.refreshToken);
      await _storage.write('is_logged_in', true);

      log('✅ User data saved locally: ${userData.username}');
      currentUser.value = userData;
    } catch (e) {
      log('❌ Error saving user data: $e');
      throw Exception('Failed to save user data locally');
    }
  }

  /// Load cached user data from storage
  Future<void> _loadCachedUserData() async {
    try {
      final userData = _storage.read('user_data');
      final isLoggedIn = _storage.read('is_logged_in') ?? false;

      if (isLoggedIn && userData != null) {
        currentUser.value = LoginData.fromJson(
          Map<String, dynamic>.from(userData),
        );
        log('✅ Cached user data loaded: ${currentUser.value?.username}');
      }
    } catch (e) {
      log('❌ Error loading cached user data: $e');
    }
  }

  /// Clear all stored user data
  Future<void> _clearStoredData() async {
    try {
      await _storage.erase();
      currentUser.value = null;
      log('✅ All stored data cleared');
    } catch (e) {
      log('❌ Error clearing stored data: $e');
    }
  }

  /// Get stored access token
  String? getStoredToken() {
    return _storage.read('access_token');
  }

  /// Check if user is logged in
  bool get isLoggedIn {
    return _storage.read('is_logged_in') ?? false;
  }

  // ============================================================================
  // MAIN LOGIN METHOD
  // ============================================================================

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      final phoneNumber = phoneController.text.trim();
      final password = passwordController.text.trim();

      log('🔐 Attempting login with Phone: $phoneNumber');

      // Prepare request body for your API
      Map<String, String> requestBody = {
        "phoneNumber": phoneNumber,
        "password": password,
      };

      // Call login API
      final loginResult = await _loginRepository.loginWithIdentifier(
        requestBody,
      );

      if (loginResult.status == ApiStatus.SUCCESS &&
          loginResult.response != null &&
          loginResult.response!.success) {
        final loginResponse = loginResult.response!;

        if (loginResponse.data != null) {
          // Save user data locally
          await _saveUserDataLocally(loginResponse.data!);

          // Show success message
          GajuriSnackbar.showLoginSuccess(
            title: 'स्वागत छ ${loginResponse.data!.username}!',
            message: 'सफलतापूर्वक लगिन भयो',
            duration: Duration(seconds: 3),
          );

          log('✅ Login successful for user: ${loginResponse.data!.username}');
          log('✅ User Type: ${loginResponse.data!.userType}');

          // Navigate based on user type
          if (loginResponse.data!.isAdmin) {
            // Navigate to admin dashboard
            Get.offAllNamed('/admin-dashboard');
          } else {
            // Navigate to farmer main screen
            Get.offAllNamed('/main');
          }
        } else {
          throw Exception('No user data received');
        }
      } else {
        // Handle login failure
        final errorMessage =
            loginResult.response?.message ??
            loginResult.message ??
            'लगिन असफल भयो';

        GajuriSnackbar.showError(
          title: 'लगिन असफल',
          message: errorMessage,
          duration: Duration(seconds: 4),
        );

        log('❌ Login failed: $errorMessage');
      }
    } catch (e) {
      log('❌ Login error: $e');

      GajuriSnackbar.showError(
        title: 'त्रुटि',
        message: 'लगिन गर्दा समस्या भयो। पुनः प्रयास गर्नुहोस्।',
        duration: Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================================
  // LOGOUT METHOD
  // ============================================================================

  Future<void> logout() async {
    try {
      log('🚪 Starting logout process...');

      // Clear form data
      phoneController.clear();
      passwordController.clear();
      isPasswordVisible.value = false;

      // Clear stored data
      await _clearStoredData();

      // Show logout message
      GajuriSnackbar.showInfo(
        title: 'अलविदा',
        message: 'सफलतापूर्वक लगआउट भयो',
        duration: Duration(seconds: 2),
      );

      // Navigate to login
      Get.offAll(() => LoginView());
    } catch (e) {
      log('❌ Logout error: $e');
      GajuriSnackbar.showError(
        title: 'त्रुटि',
        message: 'लगआउट गर्दा समस्या भयो',
        duration: Duration(seconds: 3),
      );
    }
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Get current user info
  LoginData? get getCurrentUser => currentUser.value;

  /// Check if current user is admin
  bool get isCurrentUserAdmin => currentUser.value?.isAdmin ?? false;

  /// Get current user member code (for farmers)
  String? get getCurrentUserMemberCode => currentUser.value?.memberCode;

  /// Get current user display name
  String get getCurrentUserDisplayName =>
      currentUser.value?.displayName ?? 'प्रयोगकर्ता';
}
