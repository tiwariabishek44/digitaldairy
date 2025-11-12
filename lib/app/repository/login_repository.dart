import 'package:digitaldairy/app/config/api_end_point.dart';
import 'package:digitaldairy/app/model/login_response.dart';
import 'package:digitaldairy/app/service/api_client.dart';

class LoginRepository {
  final ApiClient _apiClient = ApiClient();

  // New method for dual phone/email login
  Future<ApiResponse<LoginResponse>> loginWithIdentifier(
    Map<String, String> requestBody,
  ) async {
    final response = await _apiClient.postApi<LoginResponse>(
      ApiEndPoints.login,
      requestBody:
          requestBody, // Dynamic body containing either phoneNumber or email + password
      responseType: (json) => LoginResponse.fromJson(json),
      isTokenRequired: false,
    );
    return response;
  }
}
