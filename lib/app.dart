import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fake_store/core/constants/app_constants.dart';
import 'package:fake_store/core/routes/app_router.dart';
import 'package:fake_store/core/services/navigation_service/navigation_service.dart';
import 'package:fake_store/core/theme/cubit/theme_cubit.dart';
import 'package:fake_store/core/theme/theme.dart';
import 'package:fake_store/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:fake_store/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:fake_store/features/product/presentation/cubit/product_details_cubit.dart';
import 'package:fake_store/features/product/presentation/cubit/products_cubit.dart';
import 'package:fake_store/injection_container.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});
  
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<ThemeCubit>()),
            BlocProvider(create: (_) => getIt<AuthCubit>()),
            BlocProvider(create: (_) => getIt<ProductsCubit>()),
            BlocProvider(create: (_) => getIt<ProductDetailsCubit>()),
            BlocProvider(create: (_) => getIt<CartCubit>()),
          ],
          child: Builder(
            builder: (context) {
              final navigationService = getIt<NavigationService>();
              return BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, themeState) {
                  return MaterialApp(
                    title: AppConstants.appName,
                    navigatorKey: navigationService.navigatorKey,
                    navigatorObservers: [navigationService],
                    debugShowCheckedModeBanner: false,
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    themeMode: themeState.themeMode,
                    onGenerateRoute: _appRouter.onGenerateRoute,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}