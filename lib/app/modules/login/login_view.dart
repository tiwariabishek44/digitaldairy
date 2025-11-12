import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),

                // Simple Header
                _buildHeader(),

                SizedBox(height: 8.h),

                // Phone Number Field
                _buildPhoneField(),

                SizedBox(height: 4.h),

                // Password Field
                _buildPasswordField(),

                SizedBox(height: 2.h),

                // Forgot Password
                _buildForgotPassword(),

                SizedBox(height: 5.h),

                // Login Button
                _buildLoginButton(),

                const Spacer(),

                // Register Link
                _buildRegisterLink(),

                SizedBox(height: 3.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Simple App Title
        Text(
          'डिजिटल डेरी',
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B5E20),
            height: 1.2,
          ),
        ),

        SizedBox(height: 2.h),

        Text(
          'लगिन गर्नुहोस्',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF424242),
            height: 1.3,
          ),
        ),

        SizedBox(height: 1.h),

        Text(
          'आफ्नो मोबाइल नम्बर र पासवर्ड प्रविष्ट गर्नुहोस्',
          style: TextStyle(
            fontSize: 16.sp,
            color: const Color(0xFF757575),
            height: 1.4,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'मोबाइल नम्बर',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF212121),
            height: 1.3,
          ),
        ),

        SizedBox(height: 1.5.h),

        TextFormField(
          controller: controller.phoneController,
          validator: controller.validatePhone,
          keyboardType: TextInputType.phone,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF212121),
            height: 1.4,
          ),
          decoration: InputDecoration(
            hintText: '९८०१२३४५६७',
            hintStyle: TextStyle(
              color: const Color(0xFF9E9E9E),
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF1B5E20), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
            ),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),
            errorStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFD32F2F),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'पासवर्ड',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF212121),
            height: 1.3,
          ),
        ),

        SizedBox(height: 1.5.h),

        Obx(
          () => TextFormField(
            controller: controller.passwordController,
            validator: controller.validatePassword,
            obscureText: !controller.isPasswordVisible.value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF212121),
              height: 1.4,
            ),
            decoration: InputDecoration(
              hintText: 'पासवर्ड लेख्नुहोस्',
              hintStyle: TextStyle(
                color: const Color(0xFF9E9E9E),
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: const Color(0xFF757575),
                  size: 6.w,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFE0E0E0),
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFE0E0E0),
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF1B5E20),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFD32F2F),
                  width: 2,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFD32F2F),
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: const Color(0xFFFAFAFA),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.h,
              ),
              errorStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFD32F2F),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: controller.forgotPassword,
        child: Text(
          'पासवर्ड बिर्सनुभयो?',
          style: TextStyle(
            fontSize: 15.sp,
            color: const Color(0xFF1B5E20),
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 6.h,
        child: ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.login,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B5E20),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          child: controller.isLoading.value
              ? SizedBox(
                  width: 5.w,
                  height: 5.w,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : Text(
                  'लगिन गर्नुहोस्',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return GestureDetector(
      onTap: controller.goToRegister,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color.fromARGB(255, 182, 182, 182)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'खाता छैन? ',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF757575),
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                  ),
                ),
                GestureDetector(
                  onTap: controller.goToRegister,
                  child: Text(
                    'दर्ता गर्नुहोस्',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1B5E20),
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
