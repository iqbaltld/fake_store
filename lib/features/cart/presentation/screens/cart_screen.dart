import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fake_store/core/theme/colors.dart';
import 'package:fake_store/core/widgets/others/app_text.dart';
import 'package:fake_store/generated/l10n.dart';
import '../cubit/cart_cubit.dart';
import '../widgets/cart_item.dart';
import '../widgets/cart_summary.dart';
import '../widgets/empty_cart.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          S.of(context).shoppingCart,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.white),
        elevation: 0,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          // Initialize cart if in initial state
          if (state is CartInitial) {
            context.read<CartCubit>().loadCartItems();
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return EmptyCart(
                onContinueShopping: () => Navigator.pop(context),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(8.w),
                    itemCount: state.items.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return CartItemWidget(
                        item: item,
                        onRemove: () {
                          context.read<CartCubit>().removeFromCart(
                            item.product.id,
                          );
                        },
                        onIncrement: () {
                          context.read<CartCubit>().incrementQuantity(
                            item.product.id,
                          );
                        },
                        onDecrement: () {
                          context.read<CartCubit>().decrementQuantity(
                            item.product.id,
                          );
                        },
                      );
                    },
                  ),
                ),
                CartSummary(
                  total: state.total,
                  itemCount: state.itemCount,
                  onCheckout: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          S.of(context).featureComingSoon,
                        ),
                        backgroundColor: AppColors.info,
                      ),
                    );
                  },
                ),
              ],
            );
          } else if (state is CartError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  SizedBox(height: 16.h),
                  AppText.body(
                    state.message,
                    textAlign: TextAlign.center,
                    color: AppColors.error,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => context.read<CartCubit>().loadCartItems(),
                    child: AppText.body(
                      S.of(context).retry,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
