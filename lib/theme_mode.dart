import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const defaultTheme = ThemeMode.system;

Future<void> saveThemeMode(ThemeMode mode) async {
  final pref = await SharedPreferences.getInstance();
  pref.setString('theme_mode', mode.name); // ex ('theme_mode', 'light')
}

Future<ThemeMode> loadThemeMode(SharedPreferences? pref) async {
  if (pref != null) {
    return toMode(pref.getString('theme_mode') ?? defaultTheme.name);
  }
  // 再代入できないprefの代わりに_prefを使用
  final _pref = await SharedPreferences.getInstance();
  return toMode(_pref.getString('theme_mode') ?? defaultTheme.name);
}

ThemeMode toMode(String str) {
  return ThemeMode.values.where((val) => val.name == str).first;
}

extension ThemeModeEx on ThemeMode {
  String get name => toString().split('.').last; //ThemeMode.light.name == light
}
