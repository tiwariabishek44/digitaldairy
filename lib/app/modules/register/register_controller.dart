import 'dart:developer';
import 'package:digitaldairy/app/modules/login/login_view.dart';
import 'package:digitaldairy/app/modules/login/login_controller.dart';
import 'package:digitaldairy/app/service/registration_service.dart';
import 'package:digitaldairy/app/widget/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  // Form controllers
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final memberCodeController = TextEditingController();

  // Registration service
  final RegistrationService _registrationService = RegistrationService();

  // Observable variables
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    memberCodeController.dispose();
    super.onClose();
  }

  // ============================================================================
  // UI METHODS
  // ============================================================================

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void goToLogin() {
    Get.to(() => LoginView());
  }

  // ============================================================================
  // VALIDATION METHODS
  // ============================================================================

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'कृपया नाम लेख्नुहोस्';
    }
    if (value.length < 3) {
      return 'नाम कम्तिमा ३ अक्षरको हुनुपर्छ';
    }
    if (value.length > 50) {
      return 'नाम ५० अक्षर भन्दा बढी हुनुहुँदैन';
    }
    // Check if name contains only valid characters (letters, spaces, nepali chars)
    if (!RegExp(r'^[a-zA-Z\u0900-\u097F\s]+$').hasMatch(value)) {
      return 'नाममा केवल अक्षर र स्पेस मात्र हुनुपर्छ';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'कृपया पासवर्ड लेख्नुहोस्';
    }
    if (value.length < 6) {
      return 'पासवर्ड कम्तिमा ६ अक्षरको हुनुपर्छ';
    }
    if (value.length > 20) {
      return 'पासवर्ड २० अक्षर भन्दा बढी हुनुहुँदैन';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'कृपया फोन नम्बर लेख्नुहोस्';
    }
    if (value.length != 10) {
      return 'फोन नम्बर १० अंकको हुनुपर्छ';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'फोन नम्बरमा केवल संख्या हुनुपर्छ';
    }
    if (!value.startsWith('98')) {
      return 'फोन नम्बर ९८ बाट सुरु हुनुपर्छ';
    }
    return null;
  }

  String? validateMemberCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'कृपया सदस्य कोड लेख्नुहोस्';
    }

    // Convert to number and validate
    final numericValue = int.tryParse(value);
    if (numericValue == null) {
      return 'सदस्य कोडमा केवल संख्या हुनुपर्छ';
    }

    if (numericValue < 1) {
      return 'सदस्य कोड १ वा बढी हुनुपर्छ';
    }

    if (numericValue > 9999) {
      return 'सदस्य कोड ९९९९ भन्दा बढी हुनुहुँदैन';
    }

    return null;
  }

  /// Format member code to F format (e.g., 1 -> F0001, 123 -> F0123)
  String _formatMemberCode(String input) {
    final numericValue = int.tryParse(input.trim()) ?? 0;
    return 'F${numericValue.toString().padLeft(4, '0')}';
  }

  // ============================================================================
  // MAIN REGISTRATION METHOD
  // ============================================================================

  Future<void> register() async {
    // Validate form
    if (!formKey.currentState!.validate()) {
      GajuriSnackbar.showValidationError(
        title: 'जानकारी अधूरो',
        message: 'कृपया सबै फिल्डहरू सही तरिकाले भर्नुहोस्',
        duration: Duration(seconds: 3),
      );
      return;
    }

    isLoading.value = true;

    try {
      final username = usernameController.text.trim();
      final password = passwordController.text.trim();
      final phoneNumber = phoneController.text.trim();
      final rawMemberCode = memberCodeController.text.trim();

      // Format member code (e.g., 1 -> F0001, 123 -> F0123)
      final formattedMemberCode = _formatMemberCode(rawMemberCode);

      log('📋 Starting registration process...');
      log('👤 Username: $username');
      log('📱 Phone: $phoneNumber');
      log('🔖 Raw Member Code: $rawMemberCode');
      log('🔖 Formatted Member Code: $formattedMemberCode');

      // Show loading snackbar with Nepali message
      GajuriSnackbar.showLoading(
        title: 'खाता बनाउँदै...',
        message: 'कृपया प्रतीक्षा गर्नुहोस्',
      );

      // Call registration service
      final registrationResult = await _registrationService.registerUser(
        username: username,
        password: password,
        phoneNumber: phoneNumber,
        memberCode: formattedMemberCode,
        isAdmin: false, // Farmers are not admin
        showLoadingSnackbar: false, // We're showing our own loading
      );

      // Dismiss loading snackbar
      GajuriSnackbar.dismiss();

      if (registrationResult.isSuccess) {
        // Registration successful
        log('✅ Registration successful for: $username');

        // Show success message in Nepali
        GajuriSnackbar.showRegistrationSuccess(
          title: 'स्वागत छ ${registrationResult.username}!',
          message:
              'तपाईंको खाता सफलतापूर्वक बनाइयो। सदस्य कोड: $formattedMemberCode',
          duration: Duration(seconds: 5),
        );

        // Store credentials for auto-login
        final savedPhone = phoneNumber;
        final savedPassword = password;

        // Clear form data
        _clearForm();

        // Navigate to login page and auto-fill credentials
        await Future.delayed(Duration(seconds: 2));
        Get.offAll(() => LoginView());

        // Auto-fill login form
        await Future.delayed(Duration(milliseconds: 500));
        _autoFillLoginCredentials(savedPhone, savedPassword);

        // Show guidance message
        await Future.delayed(Duration(seconds: 1));
        GajuriSnackbar.showInfo(
          title: 'लगिन गर्नुहोस्',
          message:
              'तपाईंको फोन नम्बर र पासवर्ड पहिले नै भरिएको छ। लगिन बटन थिच्नुहोस्।',
          duration: Duration(seconds: 4),
        );
      } else {
        // Registration failed
        log('❌ Registration failed: ${registrationResult.message}');

        // Show error message in Nepali
        String nepaliErrorMessage = _translateErrorMessage(
          registrationResult.message,
          registrationResult.errorCode,
        );

        GajuriSnackbar.showError(
          title: 'दर्ता असफल',
          message: nepaliErrorMessage,
          duration: Duration(seconds: 5),
        );
      }
    } catch (e) {
      log('❌ Registration exception: $e');

      // Dismiss any loading snackbar
      GajuriSnackbar.dismiss();

      // Show generic error message
      GajuriSnackbar.showError(
        title: 'त्रुटि',
        message: 'दर्ता गर्दा समस्या भयो। कृपया पुनः प्रयास गर्नुहोस्।',
        duration: Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Auto-fill login credentials after registration
  void _autoFillLoginCredentials(String phone, String password) {
    try {
      if (Get.isRegistered<LoginController>()) {
        final loginController = Get.find<LoginController>();
        loginController.phoneController.text = phone;
        loginController.passwordController.text = password;
        log('✅ Auto-filled login credentials');
      }
    } catch (e) {
      log('❌ Error auto-filling login credentials: $e');
    }
  }

  /// Clear all form fields
  void _clearForm() {
    usernameController.clear();
    passwordController.clear();
    phoneController.clear();
    memberCodeController.clear();
    isPasswordVisible.value = false;
  }

  /// Translate error messages to Nepali
  String _translateErrorMessage(String message, String? errorCode) {
    switch (errorCode) {
      case 'DUPLICATE_DATA':
        return 'यो फोन नम्बर वा सदस्य कोड पहिले नै प्रयोग भइसकेको छ';
      case 'INVALID_INPUT':
        return 'गलत जानकारी प्रविष्ट गरिएको छ। कृपया जाँच गर्नुहोस्';
      case 'NETWORK_ERROR':
        return 'इन्टरनेट जडान समस्या। कृपया जडान जाँच गर्नुहोस्';
      case 'TIMEOUT_ERROR':
        return 'अनुरोध समय सकिएको छ। कृपया पुनः प्रयास गर्नुहोस्';
      default:
        // Check for specific error messages
        if (message.toLowerCase().contains('phone')) {
          return 'यो फोन नम्बर पहिले नै प्रयोग भइसकेको छ';
        } else if (message.toLowerCase().contains('member') ||
            message.toLowerCase().contains('code')) {
          return 'यो सदस्य कोड पहिले नै प्रयोग भइसकेको छ';
        } else if (message.toLowerCase().contains('network') ||
            message.toLowerCase().contains('connection')) {
          return 'इन्टरनेट जडान समस्या छ';
        }
        return 'दर्ता गर्दा समस्या भयो। कृपया पुनः प्रयास गर्नुहोस्।';
    }
  }

  /// Pre-fill form for testing (remove in production)
  void fillTestData() {
    if (Get.isRegistered<RegisterController>()) {
      usernameController.text = 'राम बहादुर';
      passwordController.text = 'test123';
      phoneController.text = '9801234567';
      memberCodeController.text = '1';
    }
  }

  /// Preview formatted member code as user types
  String getFormattedMemberCodePreview() {
    final input = memberCodeController.text.trim();
    if (input.isEmpty) return '';

    final numericValue = int.tryParse(input);
    if (numericValue == null) return input;

    return _formatMemberCode(input);
  }
}
