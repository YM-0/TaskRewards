import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _selectedTheme;

  ThemeData light = ThemeData.light().copyWith(
      // フォント設定　英語フォントからの日本語フォント
      textTheme: ThemeData.light()
          .textTheme
          .apply(fontFamily: "Oswald", fontFamilyFallback: ["Noto Sans JP"]),
      colorScheme:
          const ColorScheme.light(primary: Color.fromARGB(255, 90, 173, 184)));

  ThemeData dark = ThemeData.dark().copyWith(
      textTheme: ThemeData.dark()
          .textTheme
          .apply(fontFamily: "Oswald", fontFamilyFallback: ["Noto Sans JP"]),
      primaryColor: Colors.black);

  ThemeProvider({required bool isDarkMode}) {
    _selectedTheme = isDarkMode ? dark : light;
  }

  Future<void> swapTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_selectedTheme == dark) {
      _selectedTheme = light;
      prefs.setBool("isDarkTheme", false);
    } else {
      _selectedTheme = dark;
      prefs.setBool("isDarkTheme", true);
    }
    notifyListeners();
  }

  ThemeData get getTheme => _selectedTheme;
}
