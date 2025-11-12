class ApiEndPoints {
  static const String baseUrl = "http://localhost:8080";
  // "http://192.168.18.12:8080";

  // ============================================================================
  // AUTH ENDPOINTS
  // ============================================================================

  /// User registration endpoint
  static const String register = "$baseUrl/api/auth/register";

  /// User login endpoint
  static const String login = "$baseUrl/api/auth/login";

  // ============================================================================
  // MILK RECORDS ENDPOINTS
  // ============================================================================

  /// Get farmer milk records by member code and Nepali month
  /// Query Parameters:
  /// - memberCode: Farmer member code (e.g., F0013)
  /// - nepaliMonth: Nepali month in format YYYY/MM (e.g., 2082/07)
  static const String farmerMilkRecords =
      "$baseUrl/api/milk-records/farmer-records";

  /// Complete URL builder for farmer milk records
  /// Example: getFarmerMilkRecordsUrl("F0013", "2082/07")
  /// Returns: http://localhost:8080/api/milk-records/farmer-records?memberCode=F0013&nepaliMonth=2082/07
  static String getFarmerMilkRecordsUrl({
    required String memberCode,
    required String nepaliMonth,
  }) {
    return "$farmerMilkRecords?memberCode=$memberCode&nepaliMonth=$nepaliMonth";
  }
}
