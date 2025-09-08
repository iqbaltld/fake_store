import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fake_store/core/theme/colors.dart';
import 'package:fake_store/core/widgets/others/app_text.dart';
import 'package:fake_store/core/widgets/others/custom_button.dart';
import 'package:fake_store/features/cart/presentation/cubit/cart_cubit.dart';
import '../cubit/product_details_cubit.dart';
import '../widgets/product_details_shimmer.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String routeName = '/product-details';
  
  final int productId;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductDetailsCubit>().loadProductDetails(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          'Product Details',
          style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.white),
        elevation: 0,
      ),
      body: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          if (state is ProductDetailsLoading) {
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
                                  '${product.rating.rate} (${product.rating.count} reviews)',
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
                        const AppText.heading3('Description'),
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
                                const SnackBar(
                                  content: Text('Added to cart successfully!'),
                                  backgroundColor: AppColors.success,
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          },
                          child: CustomButton(
                            text: 'Add to Cart',
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
                      context.read<ProductDetailsCubit>().loadProductDetails(widget.productId);
                    },
                    child: const AppText.body('Retry', color: AppColors.white),
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