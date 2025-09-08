import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'colors.dart';

class AppTextStyle {
  static TextStyle heading1 = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
    color: AppColors.onSurface,
  );

  static TextStyle heading2 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
    color: AppColors.onSurface,
  );

  static TextStyle heading3 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
    color: AppColors.onSurface,
  );

  static TextStyle subHeading = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
    color: AppColors.onSurface,
  );

  static TextStyle body = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    fontFamily: 'Poppins',
    color: AppColors.onSurface,
  );

  static TextStyle caption = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    fontFamily: 'Poppins',
    color: AppColors.grey,
  );

  static TextStyle button = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
    color: AppColors.white,
  );
}