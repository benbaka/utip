

import 'package:flutter/material.dart';

class ThemeSelectorModel with ChangeNotifier {

  bool selectedTheme = false;
  ThemeData themeData = ThemeData.light();


  bool get selectedThemeGlobal => selectedTheme;

  void setToggleTheme() {
    selectedTheme = !selectedTheme;
    themeData = selectedTheme ? ThemeData.dark() : ThemeData.light() ;
    notifyListeners();
  }
}