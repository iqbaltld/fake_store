import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fake_store/core/theme/colors.dart';
import 'package:fake_store/core/widgets/others/app_text.dart';
import 'package:fake_store/core/widgets/others/app_text_field.dart';
import 'package:fake_store/core/widgets/others/custom_button.dart';
import 'package:fake_store/features/product/presentation/screens/products_screen.dart';
import 'package:fake_store/generated/l10n.dart';
import '../cubit/auth_cubit.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Create controllers and form key locally
    final usernameController = TextEditingController(text: 'johnd');
    final passwordController = TextEditingController(text: 'm38rmF\$');
    final formKey = GlobalKey<FormState>();
    final isPasswordVisible = ValueNotifier<bool>(false);

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
              key: formKey,
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
                  AppText.heading1(
                    S.of(context).appTitle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  AppText.body(
                    S.of(context).signInToContinue,
                    textAlign: TextAlign.center,
                    color: AppColors.grey,
                  ),
                  SizedBox(height: 48.h),

                  // Username Field
                  AppTextField(
                    controller: usernameController,
                    hintText: S.of(context).username,
                    keyboardType: TextInputType.text,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  SizedBox(height: 16.h),

                  // Password Field
                  ValueListenableBuilder<bool>(
                    valueListenable: isPasswordVisible,
                    builder: (context, isPasswordVisibleValue, child) {
                      return AppTextField(
                        controller: passwordController,
                        hintText: S.of(context).password,
                        obscureText: !isPasswordVisibleValue,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisibleValue
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            isPasswordVisible.value = !isPasswordVisible.value;
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 32.h),

                  // Login Button
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: S.of(context).signIn,
                        isLoading: state is AuthLoading,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthCubit>().login(
                              usernameController.text.trim(),
                              passwordController.text.trim(),
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
