import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fake_store/core/theme/colors.dart';
import 'package:fake_store/core/theme/cubit/theme_cubit.dart';
import 'package:fake_store/core/widgets/others/app_text.dart';

class ThemeSwitcher extends StatelessWidget {
  final bool showLabel;

  const ThemeSwitcher({
    super.key,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isDark = state.themeMode == ThemeMode.dark;
        
        return InkWell(
          onTap: () => context.read<ThemeCubit>().toggleTheme(),
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isDark ? Icons.light_mode : Icons.dark_mode,
                    key: ValueKey(isDark),
                    color: isDark ? Colors.yellow : Colors.grey[600],
                  ),
                ),
                if (showLabel) ...[
                  SizedBox(width: 8.w),
                  AppText.body(
                    isDark ? 'Light Mode' : 'Dark Mode',
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class ThemeSwitcherTile extends StatelessWidget {
  const ThemeSwitcherTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isDark = state.themeMode == ThemeMode.dark;
        
        return ListTile(
          leading: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              key: ValueKey(isDark),
              color: isDark ? Colors.yellow : Colors.grey[600],
            ),
          ),
          title: AppText.body(
            isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          ),
          subtitle: AppText.caption(
            'Change the app appearance',
            color: AppColors.grey,
          ),
          trailing: Switch.adaptive(
            value: isDark,
            onChanged: (value) => context.read<ThemeCubit>().toggleTheme(),
            activeColor: AppColors.primary,
          ),
          onTap: () => context.read<ThemeCubit>().toggleTheme(),
        );
      },
    );
  }
}