import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences _prefs;

  static const String _themeModeKey = 'theme_mode';
  static const String _localeKey = 'locale';

  SettingsCubit({required SharedPreferences prefs})
      : _prefs = prefs,
        super(const SettingsState()) {
    _loadSettings();
  }

  void _loadSettings() {
    final isDark = _prefs.getBool(_themeModeKey) ?? false;
    final langCode = _prefs.getString(_localeKey) ?? 'ar';

    emit(state.copyWith(
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      locale: langCode == 'ar' ? const Locale('ar', 'AE') : const Locale('en', 'US'),
    ));
  }

  Future<void> toggleDarkMode(bool isDark) async {
    await _prefs.setBool(_themeModeKey, isDark);
    emit(state.copyWith(
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
    ));
  }

  Future<void> setLanguage(String langCode) async {
    await _prefs.setString(_localeKey, langCode);
    emit(state.copyWith(
      locale: langCode == 'ar' ? const Locale('ar', 'AE') : const Locale('en', 'US'),
    ));
  }
}
