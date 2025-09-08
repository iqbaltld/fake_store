import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fake_store/core/theme/colors.dart';
import 'package:fake_store/core/widgets/others/app_text.dart';
import 'package:fake_store/core/widgets/others/custom_button.dart';

class EmptyCart extends StatelessWidget {
  final VoidCallback onContinueShopping;

  const EmptyCart({
    super.key,
    required this.onContinueShopping,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80.sp,
            color: AppColors.grey,
          ),
          SizedBox(height: 16.h),
          const AppText.heading3(
            'Your cart is empty',
            color: AppColors.grey,
          ),
          SizedBox(height: 8.h),
          const AppText.body(
            'Add some products to get started',
            color: AppColors.grey,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          CustomButton(
            text: 'Continue Shopping',
            onPressed: onContinueShopping,
          ),
        ],
      ),
    );
  }
}