import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fake_store/core/theme/colors.dart';
import 'package:fake_store/core/widgets/others/app_text.dart';
import 'package:fake_store/features/cart/domain/entities/cart_item.dart';
import 'package:fake_store/generated/l10n.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.lightGrey,
              ),
              child: CachedNetworkImage(
                imageUrl: item.product.image,
                fit: BoxFit.contain,
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, color: AppColors.error),
              ),
            ),

            SizedBox(width: 12.w),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.subHeading(
                    item.product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  AppText.caption(
                    _capitalize(item.product.category),
                    color: AppColors.grey,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText.heading3(
                        '\$${item.product.price.toStringAsFixed(2)}',
                        color: AppColors.primary,
                      ),
                      Flexible(
                        child: AppText.body(
                          '${S.of(context).total}: \$${item.totalPrice.toStringAsFixed(2)}',
                          color: AppColors.darkGrey,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            // Quantity Controls
            SizedBox(
              width: 70.w,
              child: Column(
                children: [
                  // Remove Button
                  IconButton(
                    onPressed: onRemove,
                    padding: EdgeInsets.all(4.w),
                    constraints: BoxConstraints(
                      minWidth: 32.w,
                      minHeight: 32.h,
                    ),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
                      size: 20,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Quantity Controls
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grey),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: IntrinsicWidth(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: onDecrement,
                            child: Container(
                              width: 22.w,
                              height: 22.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.remove,
                                size: 12,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          Container(
                            constraints: BoxConstraints(minWidth: 20.w),
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            child: Center(
                              child: AppText.caption(
                                item.quantity.toString(),
                                color: AppColors.darkGrey,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: onIncrement,
                            child: Container(
                              width: 22.w,
                              height: 22.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 12,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
