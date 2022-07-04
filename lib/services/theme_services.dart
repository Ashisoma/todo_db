import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class THemeService {
  final _box = GetStorage();
  final _key = "isDarkMode";

// return true in the 1st ? and false in the 2nd ?
  bool _loadThemeFromStorage() => _box.read(_key) ?? false;

  // save the value of the key
  _saveValueToStorage(bool isDarkMode) => _box.write(_key, isDarkMode);

// the function we called will return false since key wasnt like initialized its just a key... i guess thats what the guy said
  ThemeMode get theme =>
      _loadThemeFromStorage() ? ThemeMode.dark : ThemeMode.light;

  void changeMyTheme() {
    Get.changeThemeMode(
        _loadThemeFromStorage() ? ThemeMode.light : ThemeMode.dark);

    _saveValueToStorage(!_loadThemeFromStorage());
  }
}
