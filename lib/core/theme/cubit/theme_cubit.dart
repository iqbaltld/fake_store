import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

@LazySingleton()
class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences _sharedPreferences;
  static const String _themeKey = 'theme_mode';

  ThemeCubit(this._sharedPreferences) : super(ThemeState.initial()) {
    _loadTheme();
  }

  void _loadTheme() {
    final themeIndex = _sharedPreferences.getInt(_themeKey) ?? 0;
    final themeMode = ThemeMode.values[themeIndex];
    emit(state.copyWith(themeMode: themeMode));
  }

  Future<void> toggleTheme() async {
    final newThemeMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    
    await _saveTheme(newThemeMode);
    emit(state.copyWith(themeMode: newThemeMode));
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    await _saveTheme(themeMode);
    emit(state.copyWith(themeMode: themeMode));
  }

  Future<void> _saveTheme(ThemeMode themeMode) async {
    await _sharedPreferences.setInt(_themeKey, themeMode.index);
  }

  bool get isDarkMode => state.themeMode == ThemeMode.dark;
  bool get isLightMode => state.themeMode == ThemeMode.light;
}