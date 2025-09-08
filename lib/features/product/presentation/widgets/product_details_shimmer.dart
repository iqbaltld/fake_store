import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fake_store/core/theme/colors.dart';

class ProductDetailsShimmer extends StatelessWidget {
  const ProductDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Image placeholder
          Shimmer.fromColors(
            baseColor: AppColors.lightGrey,
            highlightColor: AppColors.white,
            child: Container(
              width: double.infinity,
              height: 300.h,
              color: AppColors.lightGrey,
            ),
          ),
          
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category placeholder
                Shimmer.fromColors(
                  baseColor: AppColors.lightGrey,
                  highlightColor: AppColors.white,
                  child: Container(
                    width: 80.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
                
                SizedBox(height: 12.h),
                
                // Title placeholder
                Shimmer.fromColors(
                  baseColor: AppColors.lightGrey,
                  highlightColor: AppColors.white,
                  child: Container(
                    width: double.infinity,
                    height: 24.h,
                    color: AppColors.lightGrey,
                  ),
                ),
                
                SizedBox(height: 8.h),
                
                // Rating and price placeholder
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Shimmer.fromColors(
                      baseColor: AppColors.lightGrey,
                      highlightColor: AppColors.white,
                      child: Container(
                        width: 120.w,
                        height: 16.h,
                        color: AppColors.lightGrey,
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: AppColors.lightGrey,
                      highlightColor: AppColors.white,
                      child: Container(
                        width: 80.w,
                        height: 20.h,
                        color: AppColors.lightGrey,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 20.h),
                
                // Description placeholder
                Shimmer.fromColors(
                  baseColor: AppColors.lightGrey,
                  highlightColor: AppColors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100.w,
                        height: 18.h,
                        color: AppColors.lightGrey,
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: double.infinity,
                        height: 16.h,
                        color: AppColors.lightGrey,
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        width: double.infinity,
                        height: 16.h,
                        color: AppColors.lightGrey,
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        width: 200.w,
                        height: 16.h,
                        color: AppColors.lightGrey,
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 32.h),
                
                // Button placeholder
                Shimmer.fromColors(
                  baseColor: AppColors.lightGrey,
                  highlightColor: AppColors.white,
                  child: Container(
                    width: double.infinity,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}