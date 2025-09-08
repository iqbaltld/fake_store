import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fake_store/core/theme/colors.dart';
import 'package:fake_store/core/widgets/others/app_text.dart';
import 'package:fake_store/core/widgets/others/app_text_field.dart';
import 'package:fake_store/core/widgets/others/custom_button.dart';
import 'package:fake_store/features/product/presentation/screens/products_screen.dart';
import '../cubit/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill with demo credentials for FakeStore API
    _usernameController.text = 'johnd';
    _passwordController.text = 'm38rmF\$';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                Navigator.pushReplacementNamed(
                  context,
                  ProductsScreen.routeName,
                );
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo or App Name
                  Icon(
                    Icons.shopping_bag,
                    size: 80.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(height: 16.h),
                  const AppText.heading1(
                    'Fake Store',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  const AppText.body(
                    'Sign in to continue',
                    textAlign: TextAlign.center,
                    color: AppColors.grey,
                  ),
                  SizedBox(height: 48.h),

                  // Username Field
                  AppTextField(
                    controller: _usernameController,
                    hintText: 'Username',
                    keyboardType: TextInputType.text,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  SizedBox(height: 16.h),

                  // Password Field
                  AppTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: !_isPasswordVisible,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Login Button
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: 'Sign In',
                        isLoading: state is AuthLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().login(
                              _usernameController.text.trim(),
                              _passwordController.text.trim(),
                            );
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 24.h),

                  // Demo Credentials Info
                  // Container(
                  //   padding: EdgeInsets.all(16.w),
                  //   decoration: BoxDecoration(
                  //     color: AppColors.lightGrey,
                  //     borderRadius: BorderRadius.circular(8.r),
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       const AppText.caption(
                  //         'Demo Credentials:',
                  //         color: AppColors.darkGrey,
                  //       ),
                  //       SizedBox(height: 4.h),
                  //       const AppText.caption(
                  //         'Username: johnd',
                  //         color: AppColors.darkGrey,
                  //       ),
                  //       const AppText.caption(
                  //         'Password: m38rmF\$',
                  //         color: AppColors.darkGrey,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
