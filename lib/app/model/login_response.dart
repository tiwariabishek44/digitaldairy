class LoginResponse {
  final bool success;
  final LoginData? data;
  final String? message;
  final String? errorCode;

  LoginResponse({
    required this.success,
    this.data,
    this.message,
    this.errorCode,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
      message: json['message'],
      errorCode: json['errorCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
      'message': message,
      'errorCode': errorCode,
    };
  }
}

class LoginData {
  final String accessToken;
  final String refreshToken;
  final int userId;
  final String username;
  final String? phoneNumber;
  final String? email;
  final String? memberCode;
  final bool isAdmin;

  LoginData({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.username,
    this.phoneNumber,
    this.email,
    this.memberCode,
    required this.isAdmin,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      userId: json['userId'] ?? 0,
      username: json['username'] ?? '',
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      memberCode: json['memberCode'],
      isAdmin: json['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'userId': userId,
      'username': username,
      'phoneNumber': phoneNumber,
      'email': email,
      'memberCode': memberCode,
      'isAdmin': isAdmin,
    };
  }

  // Helper methods for easier access
  bool get isFarmer => !isAdmin && memberCode != null;

  String get displayName => username;

  String get userType => isAdmin ? 'Admin' : 'Farmer';

  String get contactInfo => phoneNumber ?? email ?? 'N/A';
}
