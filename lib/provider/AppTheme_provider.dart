import 'package:flutter/material.dart';
import 'package:mycontacts/model/appTheme.dart';

class ThemeProvider extends ChangeNotifier {
  AppTheme appTheme = AppTheme(isDark: false);

  void changeTheme(bool value) {
    appTheme.isDark = value;
    notifyListeners();
  }
}
