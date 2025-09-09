import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fake_store/core/theme/colors.dart';
import 'package:fake_store/core/widgets/others/app_text.dart';
import 'package:fake_store/core/widgets/others/custom_button.dart';
import 'package:fake_store/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:fake_store/generated/l10n.dart';
import '../cubit/product_details_cubit.dart';
import '../widgets/product_details_shimmer.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const String routeName = '/product-details';
  
  final int productId;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          S.of(context).productDetails,
          style: const TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.white),
        elevation: 0,
      ),
      body: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          // Initialize product details if in initial state
          if (state is ProductDetailsInitial) {
            context.read<ProductDetailsCubit>().loadProductDetails(productId);
            return const ProductDetailsShimmer();
          } else if (state is ProductDetailsLoading) {
            return const ProductDetailsShimmer();
          } else if (state is ProductDetailsLoaded) {
            final product = state.product;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Container(
                    width: double.infinity,
                    height: 300.h,
                    color: AppColors.white,
                    child: CachedNetworkImage(
                      imageUrl: product.image,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: AppColors.lightGrey,
                        highlightColor: AppColors.white,
                        child: Container(
                          color: AppColors.lightGrey,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        size: 64,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: AppText.caption(
                            _capitalize(product.category),
                            color: AppColors.primary,
                          ),
                        ),
                        
                        SizedBox(height: 12.h),
                        
                        // Title
                        AppText.heading2(product.title),
                        
                        SizedBox(height: 8.h),
                        
                        // Rating and Price Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: AppColors.warning,
                                  size: 20,
                                ),
                                SizedBox(width: 4.w),
                                AppText.body(
                                  '${product.rating.rate} (${product.rating.count} ${S.of(context).reviews})',
                                  color: AppColors.grey,
                                ),
                              ],
                            ),
                            AppText.heading2(
                              '\$${product.price.toStringAsFixed(2)}',
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 20.h),
                        
                        // Description
                        AppText.heading3(S.of(context).description),
                        SizedBox(height: 8.h),
                        AppText.body(
                          product.description,
                          color: AppColors.darkGrey,
                        ),
                        
                        SizedBox(height: 32.h),
                        
                        // Add to Cart Button
                        BlocListener<CartCubit, CartState>(
                          listener: (context, cartState) {
                            if (cartState is CartError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(cartState.message),
                                  backgroundColor: AppColors.error,
                                ),
                              );
                            } else if (cartState is CartLoaded) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(S.of(context).addedToCartSuccessfully),
                                  backgroundColor: AppColors.success,
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            }
                          },
                          child: CustomButton(
                            text: S.of(context).addToCart,
                            width: double.infinity,
                            onPressed: () {
                              context.read<CartCubit>().addToCart(product);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ProductDetailsError) {
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
                    onPressed: () {
                      context.read<ProductDetailsCubit>().loadProductDetails(productId);
                    },
                    child: AppText.body(S.of(context).retry, color: AppColors.white),
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


  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}