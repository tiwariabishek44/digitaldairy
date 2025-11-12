import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:digitaldairy/app/config/api_end_point.dart';
import 'package:digitaldairy/app/widget/custom_snackbar.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Registration Service - Handles real API calls to Spring Boot backend with professional UX
class RegistrationService {
  static final RegistrationService _instance = RegistrationService._internal();
  factory RegistrationService() => _instance;
  RegistrationService._internal();

  final Duration timeoutDuration = const Duration(seconds: 30);

  // ============================================================================
  // REGISTER USER WITH PROFESSIONAL UX - SIMPLIFIED (NO OTP)
  // ============================================================================

  Future<RegistrationResult> registerUser({
    required String username,
    required String password,
    required String phoneNumber,
    required String memberCode,
    bool isAdmin = false,
    bool showLoadingSnackbar = true,
  }) async {
    try {
      // Show loading snackbar
      if (showLoadingSnackbar) {
        GajuriSnackbar.showLoading(
          title: "Creating Account...",
          message: "Please wait while we register your account",
        );
      }

      final requestData = {
        "username": username,
        "password": password,
        "phoneNumber": phoneNumber,
        "memberCode": memberCode,
        "isAdmin": isAdmin,
      };

      log("📋 Registration data: $requestData");

      // Make direct HTTP call
      final uri = Uri.parse(ApiEndPoints.register);
      log("🔗 Registration URL: $uri");
      final response = await http
          .post(
            uri,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: jsonEncode(requestData),
          )
          .timeout(timeoutDuration);

      log("📊 Response Status: ${response.statusCode}");
      log("📄 Response Body: ${response.body}");

      // Always dismiss loading snackbar
      if (showLoadingSnackbar) {
        GajuriSnackbar.dismiss();
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (data['success'] == true && data['data'] != null) {
          final registerData = data['data'] as Map<String, dynamic>;

          log("✅ Registration successful!");
          log("👤 User ID: ${registerData['userId']}");
          log("📱 Member Code: ${registerData['memberCode']}");

          // Show success snackbar
          GajuriSnackbar.showRegistrationSuccess(
            title: "Welcome ${registerData['username']}!",
            message: "Your account has been created successfully",
            duration: Duration(seconds: 5),
          );

          return RegistrationResult.success(
            userId: registerData['userId']?.toString() ?? '',
            username: registerData['username'] ?? username,
            phoneNumber: registerData['phoneNumber'] ?? phoneNumber,
            memberCode: registerData['memberCode'] ?? memberCode,
            isAdmin: registerData['isAdmin'] ?? false,
            message:
                registerData['message'] ??
                data['message'] ??
                "Registration successful",
          );
        } else {
          log("❌ Registration failed: ${data['message']}");

          // Show error snackbar
          GajuriSnackbar.showError(
            title: "Registration Failed",
            message: data['message'] ?? "Registration failed",
            duration: Duration(seconds: 5),
          );

          return RegistrationResult.error(
            message: data['message'] ?? "Registration failed",
            errorCode: data['errorCode'] ?? "REGISTRATION_FAILED",
          );
        }
      }
      // Handle specific error status codes
      else if (response.statusCode == 409) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final errorMessage =
            data['message'] ?? "Phone number or member code already exists";

        // Show specific error for duplicate data
        GajuriSnackbar.showError(
          title: "Already Registered",
          message:
              "This phone number or member code is already in use. Please try with different details.",
          duration: Duration(seconds: 6),
        );

        return RegistrationResult.error(
          message: errorMessage,
          errorCode: data['errorCode'] ?? "DUPLICATE_DATA",
        );
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        // Show validation error
        GajuriSnackbar.showValidationError(
          title: "Invalid Information",
          message: "Please check your information and try again.",
          duration: Duration(seconds: 4),
        );

        return RegistrationResult.error(
          message: data['message'] ?? "Invalid input data",
          errorCode: data['errorCode'] ?? "INVALID_INPUT",
        );
      } else {
        // Show generic error for other status codes
        GajuriSnackbar.showError(
          title: "Registration Failed",
          message: "Something went wrong. Please try again later.",
          duration: Duration(seconds: 5),
        );

        return RegistrationResult.error(
          message: "Registration failed with status: ${response.statusCode}",
          errorCode: "HTTP_ERROR_${response.statusCode}",
        );
      }
    } on SocketException {
      log("❌ Network error: No internet connection");

      // Always dismiss loading snackbar
      if (showLoadingSnackbar) {
        GajuriSnackbar.dismiss();
      }

      // Show network error with retry option
      GajuriSnackbar.showNetworkError(
        title: "No Internet Connection",
        message: "Please check your connection and try again.",
        duration: Duration(seconds: 8),
        onRetry: () => registerUser(
          username: username,
          password: password,
          phoneNumber: phoneNumber,
          memberCode: memberCode,
          isAdmin: isAdmin,
          showLoadingSnackbar: false, // Don't show loading again on retry
        ),
      );

      return RegistrationResult.error(
        message: "No internet connection. Please check your network.",
        errorCode: "NETWORK_ERROR",
      );
    } on TimeoutException {
      log("❌ Request timeout");

      // Always dismiss loading snackbar
      if (showLoadingSnackbar) {
        GajuriSnackbar.dismiss();
      }

      // Show timeout error
      GajuriSnackbar.showError(
        title: "Request Timeout",
        message: "The request took too long. Please try again.",
        duration: Duration(seconds: 5),
      );

      return RegistrationResult.error(
        message: "Request timeout. Please try again.",
        errorCode: "TIMEOUT_ERROR",
      );
    } catch (e) {
      log("❌ Registration exception: $e");

      // Always dismiss loading snackbar
      if (showLoadingSnackbar) {
        GajuriSnackbar.dismiss();
      }

      // Show generic error
      GajuriSnackbar.showError(
        title: "Unexpected Error",
        message: "Something unexpected happened. Please try again.",
        duration: Duration(seconds: 5),
      );

      return RegistrationResult.error(
        message: "Registration failed. Please try again.",
        errorCode: "EXCEPTION_ERROR",
      );
    }
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Clear any displayed snackbars
  static void clearSnackbars() {
    GajuriSnackbar.dismiss();
  }

  /// Show a custom registration error with retry option
  static void showRegistrationErrorWithRetry({
    required String title,
    required String message,
    required VoidCallback onRetry,
  }) {
    GajuriSnackbar.showNetworkError(
      title: title,
      message: message,
      onRetry: onRetry,
      duration: Duration(seconds: 8),
    );
  }
}

// ============================================================================
// UPDATED RESULT CLASSES - NO OTP NEEDED
// ============================================================================

/// Registration result wrapper - Updated for simple registration
class RegistrationResult {
  final bool isSuccess;
  final String? userId;
  final String? username;
  final String? phoneNumber;
  final String? memberCode;
  final bool? isAdmin;
  final String message;
  final String? errorCode;

  RegistrationResult._({
    required this.isSuccess,
    this.userId,
    this.username,
    this.phoneNumber,
    this.memberCode,
    this.isAdmin,
    required this.message,
    this.errorCode,
  });

  factory RegistrationResult.success({
    required String userId,
    required String username,
    required String phoneNumber,
    required String memberCode,
    required bool isAdmin,
    required String message,
  }) {
    return RegistrationResult._(
      isSuccess: true,
      userId: userId,
      username: username,
      phoneNumber: phoneNumber,
      memberCode: memberCode,
      isAdmin: isAdmin,
      message: message,
    );
  }

  factory RegistrationResult.error({
    required String message,
    required String errorCode,
  }) {
    return RegistrationResult._(
      isSuccess: false,
      message: message,
      errorCode: errorCode,
    );
  }
}

// Note: OtpVerificationResult class removed as OTP verification is no longer needed
