import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fake_store/core/theme/colors.dart';
import 'package:fake_store/core/theme/cubit/theme_cubit.dart';
import 'package:fake_store/core/widgets/navigation/app_drawer.dart';
import 'package:fake_store/core/widgets/others/app_text.dart';
import 'package:fake_store/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:fake_store/features/cart/presentation/screens/cart_screen.dart';
import 'package:fake_store/generated/l10n.dart';
import '../cubit/products_cubit.dart';
import '../widgets/category_chip.dart';
import '../widgets/product_card.dart';
import '../widgets/products_shimmer_grid.dart';
import 'product_details_screen.dart';

class ProductsScreen extends StatefulWidget {
  static const String routeName = '/products';

  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductsCubit>().loadProducts();
    context.read<CartCubit>().loadCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: AppText(
          S.of(context).appTitle,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          // Theme Switcher
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              final isDark = themeState.themeMode == ThemeMode.dark;
              return IconButton(
                onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isDark ? Icons.light_mode : Icons.dark_mode,
                    key: ValueKey(isDark),
                    color: isDark ? Colors.yellow : AppColors.white,
                  ),
                ),
                tooltip: isDark
                    ? S.of(context).switchToLightMode
                    : S.of(context).switchToDarkMode,
              );
            },
          ),

          // Cart Icon with Badge
          BlocBuilder<CartCubit, CartState>(
            builder: (context, cartState) {
              final itemCount = cartState is CartLoaded
                  ? cartState.itemCount
                  : 0;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, CartScreen.routeName);
                    },
                    tooltip: S.of(context).shoppingCart,
                  ),
                  if (itemCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16.w,
                          minHeight: 16.h,
                        ),
                        child: Text(
                          itemCount.toString(),
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          SizedBox(width: 8.w),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, state) {
              if (state is ProductsLoaded && state.categories.isNotEmpty) {
                return Container(
                  height: 50.h,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  margin: EdgeInsets.only(top: 8.h),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: state.categories.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return CategoryChip(
                          label: S.of(context).all,
                          isSelected: state.selectedCategory == null,
                          onTap: () {
                            context
                                .read<ProductsCubit>()
                                .loadProductsByCategory(null);
                          },
                        );
                      }
                      final category = state.categories[index - 1];
                      return CategoryChip(
                        label: _capitalize(category),
                        isSelected: state.selectedCategory == category,
                        onTap: () {
                          context.read<ProductsCubit>().loadProductsByCategory(
                            category,
                          );
                        },
                      );
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          // Products Grid
          Expanded(
            child: BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                if (state is ProductsLoading) {
                  return const ProductsShimmerGrid();
                } else if (state is ProductsLoaded) {
                  if (state.products.isEmpty) {
                    return Center(
                      child: AppText.body(S.of(context).noProductsFound),
                    );
                  }
                  return Column(
                    children: [
                      // Offline indicator
                      if (state.isFromCache)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          color: AppColors.warning.withValues(alpha: 0.1),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.cloud_off,
                                size: 16,
                                color: AppColors.warning,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: AppText.caption(
                                  'Showing offline data. Pull to refresh when online.',
                                  color: AppColors.warning,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () =>
                              context.read<ProductsCubit>().refreshProducts(),
                          child: GridView.builder(
                            padding: EdgeInsets.all(16.w),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12.w,
                              mainAxisSpacing: 12.h,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: state.products.length,
                            itemBuilder: (context, index) {
                              final product = state.products[index];
                              return ProductCard(
                                product: product,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    ProductDetailsScreen.routeName,
                                    arguments: product.id,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (state is ProductsError) {
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
                          onPressed: () =>
                              context.read<ProductsCubit>().loadProducts(),
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
          ),
        ],
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
