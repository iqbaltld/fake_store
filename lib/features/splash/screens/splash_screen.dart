import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fake_store/core/theme/colors.dart';
import 'package:fake_store/core/widgets/others/app_text.dart';
import 'package:fake_store/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:fake_store/features/authentication/presentation/screens/login_screen.dart';
import 'package:fake_store/features/product/presentation/screens/products_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      context.read<AuthCubit>().checkAuthStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, ProductsScreen.routeName);
          } else if (state is AuthUnauthenticated) {
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag, size: 80.sp, color: AppColors.white),
              SizedBox(height: 24.h),
              const AppText.heading1('Fake Store', color: AppColors.white),
              SizedBox(height: 8.h),
              const AppText.body(
                'Your favorite shopping app',
                color: AppColors.white,
              ),
              SizedBox(height: 40.h),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
