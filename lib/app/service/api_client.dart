import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'session_service.dart';
import 'token_manager.dart';

//-----------------------API CLIENT-----------------------
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final SessionService _sessionService = SessionService();
  final TokenManager _tokenManager = TokenManager();

  final Duration timeoutDuration = const Duration(seconds: 30);
  bool _isRedirecting = false; // Prevent multiple redirects

  //-----------------------HEADERS-----------------------
  Map<String, String> get _jsonHeaders => {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  Map<String, String> get _multipartHeaders => {"Accept": "application/json"};

  //-----------------------AUTH HEADERS-----------------------
  Future<Map<String, String>> _getAuthHeaders({
    bool isMultipart = false,
  }) async {
    final baseHeaders = isMultipart ? _multipartHeaders : _jsonHeaders;

    final accessToken = await _tokenManager.getValidAccessToken();
    if (accessToken != null) {
      return {...baseHeaders, "Authorization": "Bearer $accessToken"};
    }

    return baseHeaders;
  }

  //-----------------------AUTH CHECK-----------------------
  bool get isAuthenticated => _sessionService.hasValidTokens;

  //-----------------------POST API-----------------------
  Future<ApiResponse<T>> postApi<T>(
    String fullUrl, {
    Map<String, dynamic>? requestBody,
    T Function(dynamic json)? responseType,
    bool isTokenRequired = true,
  }) async {
    try {
      // NEW PATTERN (USE THIS):
      if (isTokenRequired && !await _tokenManager.isAccessTokenValid()) {
        final refreshed = await _tokenManager.getValidAccessToken();
        if (refreshed == null) {
          // Don't redirect here for login requests - let _handleResponse decide
          // Only redirect if we're not in a login flow
          return ApiResponse.error("Session expired. Please login again.");
        }
      }
      final uri = Uri.parse(fullUrl);
      final headers = isTokenRequired ? await _getAuthHeaders() : _jsonHeaders;

      log("🚀 POST REQUEST: $uri");
      log("📋 Request Body: $requestBody");

      final response = await http
          .post(
            uri,
            headers: headers,
            body: requestBody != null ? jsonEncode(requestBody) : null,
          )
          .timeout(timeoutDuration);

      log("📊 Response Status: ${response.statusCode}");
      log("📄 Response Body: ${response.body}");

      return _handleResponse<T>(response, responseType);
    } on SocketException {
      return ApiResponse.error("No Internet Connection");
    } on TimeoutException {
      return ApiResponse.error("Request timeout. Please try again.");
    } catch (e) {
      log("❌ POST Error: $e");
      return ApiResponse.error("Something went wrong. Please try again later");
    } finally {
      _isRedirecting = false; // Reset after request
    }
  }

  //-----------------------POST MULTIPART API (FIXED)-----------------------
  Future<ApiResponse<T>> postMultipartApi<T>(
    String fullUrl, {
    Map<String, dynamic>? requestBody,
    List<File>? files,
    String fileFieldName = 'images',
    T Function(dynamic json)? responseType,
    bool isTokenRequired = true,
  }) async {
    try {
      // FIXED: Only check token for authenticated requests, not login requests
      if (isTokenRequired && !await _tokenManager.isAccessTokenValid()) {
        final refreshed = await _tokenManager.getValidAccessToken();
        if (refreshed == null) {
          // Don't redirect here - let _handleResponse decide
          return ApiResponse.error("Session expired. Please login again.");
        }
      }

      final uri = Uri.parse(fullUrl);
      var request = http.MultipartRequest('POST', uri);

      final headers = isTokenRequired
          ? await _getAuthHeaders(isMultipart: true)
          : _multipartHeaders;
      request.headers.addAll(headers);

      log("🚀 MULTIPART POST REQUEST: $uri");

      if (requestBody != null) {
        requestBody.forEach((key, value) {
          request.fields[key] = value.toString();
        });
        log("📋 Form Fields: ${request.fields}");
      }

      if (files != null && files.isNotEmpty) {
        for (int i = 0; i < files.length; i++) {
          final file = files[i];
          final multipartFile = await http.MultipartFile.fromPath(
            fileFieldName,
            file.path,
          );
          request.files.add(multipartFile);
        }
        log("📁 Files attached: ${request.files.length}");
      }

      final streamedResponse = await request.send().timeout(timeoutDuration);
      final response = await http.Response.fromStream(streamedResponse);

      log("📊 Multipart Response Status: ${response.statusCode}");
      log("📄 Multipart Response Body: ${response.body}");

      return _handleResponse<T>(response, responseType);
    } on SocketException {
      return ApiResponse.error("No Internet Connection");
    } on TimeoutException {
      return ApiResponse.error("Request timeout. Please try again.");
    } catch (e) {
      log("❌ MULTIPART POST Error: $e");
      return ApiResponse.error("Something went wrong. Please try again later");
    } finally {
      _isRedirecting = false; // Reset after request
    }
  }

  // Add these methods to your existing ApiClient class
  //-----------------------PUT API (FIXED)-----------------------
  Future<ApiResponse<T>> putApi<T>(
    String fullUrl, {
    Map<String, dynamic>? requestBody,
    T Function(dynamic json)? responseType,
    bool isTokenRequired = true,
  }) async {
    try {
      // NEW PATTERN (USE THIS):
      if (isTokenRequired && !await _tokenManager.isAccessTokenValid()) {
        final refreshed = await _tokenManager.getValidAccessToken();
        if (refreshed == null) {
          // Don't redirect here for login requests - let _handleResponse decide
          // Only redirect if we're not in a login flow
          return ApiResponse.error("Session expired. Please login again.");
        }
      }

      final uri = Uri.parse(fullUrl);
      final headers = isTokenRequired ? await _getAuthHeaders() : _jsonHeaders;

      log("🚀 PUT REQUEST: $uri");
      log("📋 Request Body: $requestBody");

      final response = await http
          .put(
            uri,
            headers: headers,
            // Only encode body if requestBody is not null
            body: requestBody != null ? jsonEncode(requestBody) : null,
          )
          .timeout(timeoutDuration);

      log("📊 PUT Response Status: ${response.statusCode}");
      log("📄 PUT Response Body: ${response.body}");

      return _handleResponse<T>(response, responseType);
    } on SocketException {
      return ApiResponse.error("No Internet Connection");
    } on TimeoutException {
      return ApiResponse.error("Request timeout. Please try again.");
    } catch (e) {
      log("❌ PUT Error: $e");
      return ApiResponse.error("Something went wrong. Please try again later");
    } finally {
      _isRedirecting = false; // Reset after request
    }
  }

  //-----------------------PUT MULTIPART API-----------------------
  Future<ApiResponse<T>> putMultipartApi<T>(
    String fullUrl, {
    Map<String, dynamic>? requestBody,
    List<File>? files,
    String fileFieldName = 'profilePicture',
    T Function(dynamic json)? responseType,
    bool isTokenRequired = true,
  }) async {
    try {
      // NEW PATTERN (USE THIS):
      if (isTokenRequired && !await _tokenManager.isAccessTokenValid()) {
        final refreshed = await _tokenManager.getValidAccessToken();
        if (refreshed == null) {
          // Don't redirect here for login requests - let _handleResponse decide
          // Only redirect if we're not in a login flow
          return ApiResponse.error("Session expired. Please login again.");
        }
      }

      final uri = Uri.parse(fullUrl);
      var request = http.MultipartRequest('PUT', uri);

      final headers = isTokenRequired
          ? await _getAuthHeaders(isMultipart: true)
          : _multipartHeaders;
      request.headers.addAll(headers);

      log("🚀 MULTIPART PUT REQUEST: $uri");

      if (requestBody != null) {
        requestBody.forEach((key, value) {
          request.fields[key] = value.toString();
        });
        log("📋 Form Fields: ${request.fields}");
      }

      if (files != null && files.isNotEmpty) {
        for (int i = 0; i < files.length; i++) {
          final file = files[i];
          final multipartFile = await http.MultipartFile.fromPath(
            fileFieldName,
            file.path,
          );
          request.files.add(multipartFile);
        }
        log("📁 Files attached: ${request.files.length}");
      }

      final streamedResponse = await request.send().timeout(timeoutDuration);
      final response = await http.Response.fromStream(streamedResponse);

      log("📊 Multipart PUT Response Status: ${response.statusCode}");
      log("📄 Multipart PUT Response Body: ${response.body}");

      return _handleResponse<T>(response, responseType);
    } on SocketException {
      return ApiResponse.error("No Internet Connection");
    } on TimeoutException {
      return ApiResponse.error("Request timeout. Please try again.");
    } catch (e) {
      log("❌ MULTIPART PUT Error: $e");
      return ApiResponse.error("Something went wrong. Please try again later");
    } finally {
      _isRedirecting = false; // Reset after request
    }
  }

  //-----------------------GET API-----------------------
  Future<ApiResponse<T>> getApi<T>(
    String fullUrl, {
    T Function(dynamic json)? responseType,
    bool isTokenRequired = true,
    Map<String, String>? queryParameters,
  }) async {
    try {
      // NEW PATTERN (USE THIS):
      if (isTokenRequired && !await _tokenManager.isAccessTokenValid()) {
        final refreshed = await _tokenManager.getValidAccessToken();
        if (refreshed == null) {
          // Don't redirect here for login requests - let _handleResponse decide
          // Only redirect if we're not in a login flow
          return ApiResponse.error("Session expired. Please login again.");
        }
      }
      Uri uri = Uri.parse(fullUrl);
      if (queryParameters != null && queryParameters.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParameters);
      }

      final headers = isTokenRequired ? await _getAuthHeaders() : _jsonHeaders;

      log("🚀 GET REQUEST: $uri");

      final response = await http
          .get(uri, headers: headers)
          .timeout(timeoutDuration);

      // log("📊 Response Status: ${response.statusCode}");
      // log("📄 Response Body: ${response.body}");

      return _handleResponse<T>(response, responseType);
    } on SocketException {
      log("❌ GET Error: No Internet Connection");
      return ApiResponse.error("No Internet Connection");
    } on TimeoutException {
      return ApiResponse.error("Request timeout. Please try again.");
    } catch (e) {
      log("❌ GET Error: $e");
      return ApiResponse.error("Something went wrong. Please try again later");
    } finally {
      _isRedirecting = false; // Reset after request
    }
  }

  //-----------------------DELETE API-----------------------
  Future<ApiResponse<T>> deleteApi<T>(
    String fullUrl, {
    Map<String, String>? queryParameters,
    T Function(dynamic json)? responseType,
    bool isTokenRequired = true,
  }) async {
    try {
      // NEW PATTERN (USE THIS):
      if (isTokenRequired && !await _tokenManager.isAccessTokenValid()) {
        final refreshed = await _tokenManager.getValidAccessToken();
        if (refreshed == null) {
          // Don't redirect here for login requests - let _handleResponse decide
          // Only redirect if we're not in a login flow
          return ApiResponse.error("Session expired. Please login again.");
        }
      }

      Uri uri = Uri.parse(fullUrl);
      if (queryParameters != null && queryParameters.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParameters);
      }

      final headers = isTokenRequired ? await _getAuthHeaders() : _jsonHeaders;

      log("🚀 DELETE REQUEST: $uri");

      final response = await http
          .delete(uri, headers: headers)
          .timeout(timeoutDuration);

      log("📊 Response Status: ${response.statusCode}");

      return _handleResponse<T>(response, responseType);
    } on SocketException {
      return ApiResponse.error("No Internet Connection");
    } on TimeoutException {
      return ApiResponse.error("Request timeout. Please try again.");
    } catch (e) {
      log("❌ DELETE Error: $e");
      return ApiResponse.error("Something went wrong. Please try again later");
    } finally {
      _isRedirecting = false; // Reset after request
    }
  }
  // File: lib/app/service/api_client.dart
  // ONLY UPDATE THE _handleResponse METHOD

  //-----------------------RESPONSE HANDLER (FIXED)-----------------------
  Future<ApiResponse<T>> _handleResponse<T>(
    http.Response response,
    T Function(dynamic json)? responseType,
  ) async {
    try {
      final jsonData = jsonDecode(response.body);
      final message = jsonData['message']?.toString().toLowerCase() ?? '';
      final errorCode = jsonData['errorCode']?.toString() ?? '';

      // Check if this is a token-related error (NOT a login credential error)
      bool isTokenError = false;

      if (response.statusCode == 401) {
        // Only treat as token error if it's actually about tokens, not login credentials
        isTokenError =
            message.contains('token') ||
            message.contains('expired') ||
            message.contains('unauthorized') ||
            errorCode.contains('TOKEN') ||
            (message.contains('invalid') && message.contains('token'));

        // Specifically exclude login credential errors
        if (message.contains('password') ||
            message.contains('credentials') ||
            message.contains('email') ||
            errorCode == 'AUTHENTICATION_FAILED') {
          isTokenError = false;
        }
      }

      // Only redirect to onboarding for actual token expiry, not login failures
      if (isTokenError && !_isRedirecting) {
        final refreshed = await _tokenManager.getValidAccessToken();
        if (refreshed == null) {
          _isRedirecting = true;
          // Get.offAll(() => OnboardingScreen());
          return ApiResponse.error("Session expired. Please login again.");
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        final data = responseType != null
            ? responseType(jsonData)
            : jsonData as T;
        return ApiResponse.completed(data);
      } else {
        final errorMessage = _extractErrorMessage(response);
        return ApiResponse.error(errorMessage);
      }
    } catch (e) {
      log("❌ Response parsing error: $e");
      return ApiResponse.error("Failed to parse response");
    } finally {
      _isRedirecting = false; // Reset after response
    }
  }

  //-----------------------ERROR MESSAGE EXTRACTOR-----------------------
  String _extractErrorMessage(http.Response response) {
    try {
      final jsonData = jsonDecode(response.body);
      if (jsonData is Map<String, dynamic> && jsonData.containsKey('message')) {
        return jsonData['message'].toString();
      }

      switch (response.statusCode) {
        case 400:
          return "Invalid request. Please check your input.";
        case 401:
          return "Authentication failed. Please login again.";
        case 403:
          return "Access denied.";
        case 404:
          return "Resource not found.";
        case 409:
          return "Conflict occurred. Data already exists.";
        case 500:
          return "Server error. Please try again later.";
        default:
          return "An error occurred. Please try again.";
      }
    } catch (e) {
      return "An error occurred. Please try again.";
    }
  }
}

//-----------------------API RESPONSE CLASS-----------------------
class ApiResponse<T> {
  ApiStatus status;
  T? response;
  String? message;

  ApiResponse.initial([this.message])
    : status = ApiStatus.INITIAL,
      response = null;

  ApiResponse.loading([this.message])
    : status = ApiStatus.LOADING,
      response = null;

  ApiResponse.completed(this.response)
    : status = ApiStatus.SUCCESS,
      message = null;

  ApiResponse.error([this.message]) : status = ApiStatus.ERROR, response = null;

  @override
  String toString() => "Status: $status\nData: $response\nMessage: $message";
}

enum ApiStatus { INITIAL, LOADING, SUCCESS, ERROR }
