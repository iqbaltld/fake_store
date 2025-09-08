import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fake_store/core/theme/colors.dart';
import 'package:fake_store/core/widgets/others/app_text.dart';
import 'package:fake_store/core/widgets/others/custom_button.dart';

class CartSummary extends StatelessWidget {
  final double total;
  final int itemCount;
  final VoidCallback onCheckout;

  const CartSummary({
    super.key,
    required this.total,
    required this.itemCount,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.subHeading(
                'Items ($itemCount)',
                color: AppColors.darkGrey,
              ),
              AppText.subHeading(
                '\$${total.toStringAsFixed(2)}',
                color: AppColors.darkGrey,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          const Divider(),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppText.heading3('Total'),
              AppText.heading3(
                '\$${total.toStringAsFixed(2)}',
                color: AppColors.primary,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          CustomButton(
            text: 'Checkout',
            width: double.infinity,
            onPressed: onCheckout,
          ),
        ],
      ),
    );
  }
}