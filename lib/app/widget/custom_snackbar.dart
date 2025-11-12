import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ============================================================================
// CUSTOM COLORS - Self-contained
// ============================================================================
class SnackbarColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  static const Color primary = Color(0xFF6366F1);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
}

// ============================================================================
// CUSTOM TEXT STYLES - Self-contained
// ============================================================================
class SnackbarTextStyles {
  static const TextStyle h4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
  );

  static TextStyle withColor(TextStyle baseStyle, Color color) {
    return baseStyle.copyWith(color: color);
  }
}

class GajuriSnackbar {
  // ============================================================================
  // SUCCESS SNACKBARS
  // ============================================================================

  /// Registration success snackbar
  static void showRegistrationSuccess({
    required String title,
    required String message,
    Duration? duration,
  }) {
    _showCustomSnackbar(
      type: SnackbarType.success,
      title: title,
      message: message,
      icon: Icons.check_circle_outline,
      duration: duration ?? const Duration(seconds: 4),
      hapticFeedback: true,
    );
  }

  /// Login success snackbar
  static void showLoginSuccess({
    required String title,
    required String message,
    Duration? duration,
  }) {
    _showCustomSnackbar(
      type: SnackbarType.success,
      title: title,
      message: message,
      icon: Icons.login_outlined,
      duration: duration ?? const Duration(seconds: 3),
      hapticFeedback: true,
    );
  }

  /// Upload success (post, product, job)
  static void showUploadSuccess({
    required String title,
    required String message,
    Duration? duration,
  }) {
    _showCustomSnackbar(
      type: SnackbarType.success,
      title: title,
      message: message,
      icon: Icons.cloud_done_outlined,
      duration: duration ?? const Duration(seconds: 3),
      hapticFeedback: true,
    );
  }

  /// Update success
  static void showUpdateSuccess({
    required String title,
    required String message,
    Duration? duration,
  }) {
    _showCustomSnackbar(
      type: SnackbarType.success,
      title: title,
      message: message,
      icon: Icons.verified_outlined,
      duration: duration ?? const Duration(seconds: 3),
      hapticFeedback: true,
    );
  }

  // ============================================================================
  // ERROR SNACKBARS
  // ============================================================================

  /// General error snackbar
  static void showError({
    required String title,
    required String message,
    Duration? duration,
    bool isDismissible = true,
  }) {
    _showCustomSnackbar(
      type: SnackbarType.error,
      title: title,
      message: message,
      icon: Icons.error_outline,
      duration: duration ?? const Duration(seconds: 5),
      isDismissible: isDismissible,
      hapticFeedback: true,
    );
  }

  /// Network error snackbar
  static void showNetworkError({
    String? title,
    String? message,
    Duration? duration,
    VoidCallback? onRetry,
  }) {
    _showCustomSnackbar(
      type: SnackbarType.error,
      title: title ?? "Connection Error",
      message:
          message ?? "Please check your internet connection and try again.",
      icon: Icons.wifi_off_outlined,
      duration: duration ?? const Duration(seconds: 6),
      hapticFeedback: true,
    );
  }

  /// Validation error snackbar
  static void showValidationError({
    String? title,
    required String message,
    Duration? duration,
  }) {
    _showCustomSnackbar(
      type: SnackbarType.warning,
      title: title ?? "Invalid Input",
      message: message,
      icon: Icons.warning_outlined,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  // ============================================================================
  // INFO SNACKBARS
  // ============================================================================

  /// Info snackbar
  static void showInfo({
    required String title,
    required String message,
    Duration? duration,
  }) {
    _showCustomSnackbar(
      type: SnackbarType.info,
      title: title,
      message: message,
      icon: Icons.info_outline,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// OTP sent snackbar
  static void showOtpSent({required String email, Duration? duration}) {
    _showCustomSnackbar(
      type: SnackbarType.info,
      title: "Verification Code Sent",
      message: "Code sent to $email",
      icon: Icons.sms_outlined,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  /// Loading snackbar (persistent until manually dismissed)
  static void showLoading({required String title, String? message}) {
    _showCustomSnackbar(
      type: SnackbarType.loading,
      title: title,
      message: message ?? "Please wait...",
      icon: Icons.hourglass_empty_outlined,
      duration: const Duration(days: 1), // Persistent
      isDismissible: false,
      showCloseButton: false,
    );
  }

  /// Dismiss current snackbar
  static void dismiss() {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
  }

  // ============================================================================
  // CORE SNACKBAR METHOD
  // ============================================================================

  static void _showCustomSnackbar({
    required SnackbarType type,
    required String title,
    required String message,
    required IconData icon,
    required Duration duration,
    bool isDismissible = true,
    bool showCloseButton = true,
    bool hapticFeedback = false,
    VoidCallback? onRetry,
  }) {
    // Haptic feedback for important notifications
    if (hapticFeedback) {
      HapticFeedback.lightImpact();
    }

    // Dismiss any existing snackbar
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.snackbar(
      "", // Empty title - we'll use custom widget
      "", // Empty message - we'll use custom widget
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      duration: duration,
      isDismissible: isDismissible,
      dismissDirection: DismissDirection.up,
      animationDuration: const Duration(milliseconds: 600),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      titleText: Container(), // Empty
      messageText: _gajuriSnackbarWidget(
        type: type,
        title: title,
        message: message,
        icon: icon,
        showCloseButton: showCloseButton,
        onRetry: onRetry,
      ),
    );
  }
}

// ============================================================================
// SNACKBAR TYPES
// ============================================================================

enum SnackbarType { success, error, warning, info, loading }

// ============================================================================
// PROFESSIONAL SNACKBAR WIDGET
// ============================================================================

class _gajuriSnackbarWidget extends StatefulWidget {
  final SnackbarType type;
  final String title;
  final String message;
  final IconData icon;
  final bool showCloseButton;
  final VoidCallback? onRetry;

  const _gajuriSnackbarWidget({
    required this.type,
    required this.title,
    required this.message,
    required this.icon,
    this.showCloseButton = true,
    this.onRetry,
  });

  @override
  _gajuriSnackbarWidgetState createState() => _gajuriSnackbarWidgetState();
}

class _gajuriSnackbarWidgetState extends State<_gajuriSnackbarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimation();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );
  }

  void _startAnimation() {
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            margin: EdgeInsets.fromLTRB(3.w, 2.5.h, 3.w, 0),
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(16),
              shadowColor: _getTypeColor().withOpacity(0.3),
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: SnackbarColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _getTypeColor(), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: _getTypeColor().withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon
                      _buildIcon(),

                      SizedBox(width: 3.w),
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Title
                            Text(
                              widget.title,
                              style: SnackbarTextStyles.withColor(
                                SnackbarTextStyles.h4.copyWith(fontSize: 16.sp),
                                SnackbarColors.textPrimary,
                              ),
                            ),

                            if (widget.message.isNotEmpty) ...[
                              SizedBox(height: 0.8.h),
                              // Message
                              Text(
                                widget.message,
                                style: SnackbarTextStyles.bodySmall.copyWith(
                                  fontSize: 14.sp,
                                  height: 1.4,
                                  color: SnackbarColors.textSecondary,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Action buttons
                      if (widget.showCloseButton) _buildCloseButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 10.w,
      height: 10.w,
      decoration: BoxDecoration(
        color: _getTypeColor().withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: widget.type == SnackbarType.loading
          ? SizedBox(
              width: 5.w,
              height: 5.w,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(_getTypeColor()),
              ),
            )
          : Icon(widget.icon, size: 5.w, color: _getTypeColor()),
    );
  }

  Widget _buildCloseButton() {
    return GestureDetector(
      onTap: () => Get.closeCurrentSnackbar(),
      child: Container(
        width: 6.w,
        height: 6.w,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.close, size: 4.w, color: Colors.grey[600]),
      ),
    );
  }

  Color _getTypeColor() {
    switch (widget.type) {
      case SnackbarType.success:
        return SnackbarColors.success;
      case SnackbarType.error:
        return SnackbarColors.error;
      case SnackbarType.warning:
        return SnackbarColors.warning;
      case SnackbarType.info:
        return SnackbarColors.info;
      case SnackbarType.loading:
        return SnackbarColors.primary;
    }
  }
}
