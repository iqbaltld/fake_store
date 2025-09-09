import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:equatable/equatable.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  static const String _languageKey = 'language_code';
  final SharedPreferences _sharedPreferences;

  LanguageCubit(this._sharedPreferences) 
      : super(LanguageState(locale: _getInitialLocale(_sharedPreferences)));

  static Locale _getInitialLocale(SharedPreferences prefs) {
    final languageCode = prefs.getString(_languageKey);
    if (languageCode != null) {
      return Locale(languageCode);
    }
    return const Locale('en'); // Default to English
  }

  void changeLanguage(String languageCode) {
    _sharedPreferences.setString(_languageKey, languageCode);
    emit(LanguageState(locale: Locale(languageCode)));
  }

  void toggleLanguage() {
    final newLanguageCode = state.locale.languageCode == 'en' ? 'ar' : 'en';
    changeLanguage(newLanguageCode);
  }
}