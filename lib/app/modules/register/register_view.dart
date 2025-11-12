import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(RegisterController());

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
                SizedBox(height: 6.h),

                // Enhanced Header
                _buildHeader(),

                SizedBox(height: 4.h),

                // Scrollable Form
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Username Field
                        _buildUsernameField(),

                        SizedBox(height: 3.h),

                        // Password Field
                        _buildPasswordField(),

                        SizedBox(height: 3.h),

                        // Phone Field
                        _buildPhoneField(),

                        SizedBox(height: 3.h),

                        // Member Code Field
                        _buildMemberCodeField(),

                        SizedBox(height: 4.h),

                        // Register Button
                        _buildRegisterButton(),

                        SizedBox(height: 2.h),

                        // Divider
                        _buildDivider(),

                        SizedBox(height: 2.h),

                        // Login Link
                        _buildLoginLink(),

                        SizedBox(height: 2.h),

                        // Footer
                        _buildFooter(),

                        SizedBox(height: 2.h),
                      ],
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

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 3.h),

        Text(
          'नयाँ खाता बनाउनुहोस्',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF212121),
            height: 1.2,
          ),
        ),

        SizedBox(height: 1.h),

        Text(
          'डिजिटल डेरी सदस्यको रूपमा दर्ता गर्नुहोस्',
          style: TextStyle(
            fontSize: 16.sp,
            color: const Color(0xFF616161),
            height: 1.4,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'पूरा नाम',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF212121),
                height: 1.3,
              ),
            ),
            Text(
              ' *',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFD32F2F),
              ),
            ),
          ],
        ),

        SizedBox(height: 1.5.h),

        TextFormField(
          controller: controller.usernameController,
          validator: controller.validateUsername,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF212121),
            height: 1.4,
          ),
          decoration: InputDecoration(
            hintText: 'आफ्नो पूरा नाम लेख्नुहोस्',
            hintStyle: TextStyle(
              color: const Color(0xFF9E9E9E),
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Container(
              padding: EdgeInsets.all(3.w),
              child: Icon(
                Icons.person_outline,
                color: const Color(0xFF757575),
                size: 6.w,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF1B5E20),
                width: 2.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFD32F2F),
                width: 2.5,
              ),
            ),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.2.h,
            ),
            errorStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFD32F2F),
              height: 1.3,
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
        Row(
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
            Text(
              ' *',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFD32F2F),
              ),
            ),
          ],
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
              hintText: 'कम्तिमा ६ अक्षरको पासवर्ड',
              hintStyle: TextStyle(
                color: const Color(0xFF9E9E9E),
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Container(
                padding: EdgeInsets.all(3.w),
                child: Icon(
                  Icons.lock_outline,
                  color: const Color(0xFF757575),
                  size: 6.w,
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: const Color(0xFF757575),
                  size: 6.w,
                ),
                onPressed: controller.togglePasswordVisibility,
                splashRadius: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFFE0E0E0),
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFFE0E0E0),
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFF1B5E20),
                  width: 2.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFFD32F2F),
                  width: 2,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFFD32F2F),
                  width: 2.5,
                ),
              ),
              filled: true,
              fillColor: const Color(0xFFFAFAFA),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.2.h,
              ),
              errorStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFD32F2F),
                height: 1.3,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            Text(
              ' *',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFD32F2F),
              ),
            ),
          ],
        ),

        SizedBox(height: 1.5.h),

        TextFormField(
          controller: controller.phoneController,
          validator: controller.validatePhone,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF212121),
            height: 1.4,
            letterSpacing: 0.5,
          ),
          decoration: InputDecoration(
            hintText: '९८०१२३४५६७',
            hintStyle: TextStyle(
              color: const Color(0xFF9E9E9E),
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
            ),
            prefixIcon: Container(
              padding: EdgeInsets.all(3.w),
              child: Icon(
                Icons.phone_android,
                color: const Color(0xFF757575),
                size: 6.w,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF1B5E20),
                width: 2.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFD32F2F),
                width: 2.5,
              ),
            ),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.2.h,
            ),
            errorStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFD32F2F),
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMemberCodeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'सदस्य कोड',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF212121),
                height: 1.3,
              ),
            ),
            Text(
              ' *',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFD32F2F),
              ),
            ),
          ],
        ),

        SizedBox(height: 1.5.h),

        TextFormField(
          keyboardType: TextInputType.number,
          controller: controller.memberCodeController,
          validator: controller.validateMemberCode,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF212121),
            height: 1.4,
            letterSpacing: 0.5,
          ),
          decoration: InputDecoration(
            hintText: '1',
            hintStyle: TextStyle(
              color: const Color(0xFF9E9E9E),
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
            ),
            prefixIcon: Container(
              padding: EdgeInsets.all(3.w),
              child: Icon(
                Icons.badge_outlined,
                color: const Color(0xFF757575),
                size: 6.w,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF1B5E20),
                width: 2.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFD32F2F),
                width: 2.5,
              ),
            ),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.2.h,
            ),
            errorStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFD32F2F),
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 6.5.h,
        child: ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.register,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B5E20),
            foregroundColor: Colors.white,
            disabledBackgroundColor: const Color(0xFF1B5E20).withOpacity(0.7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2,
            shadowColor: const Color(0xFF1B5E20).withOpacity(0.3),
          ),
          child: controller.isLoading.value
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 5.w,
                      height: 5.w,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'दर्ता गर्दै...',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ],
                )
              : Text(
                  'दर्ता गर्नुहोस्',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: const Color(0xFFE0E0E0))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'वा',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF9E9E9E),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: const Color(0xFFE0E0E0))),
      ],
    );
  }

  Widget _buildLoginLink() {
    return GestureDetector(
      onTap: controller.goToLogin,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 4.w),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF1B5E20), width: 1.5),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.login_outlined,
              color: const Color(0xFF1B5E20),
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'पहिले नै खाता छ? लगिन गर्नुहोस्',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1B5E20),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          Text(
            'डिजिटल डेरी © २०२५',
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF9E9E9E),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'किसानहरूका लागि बनाइएको',
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFFBDBDBD),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
