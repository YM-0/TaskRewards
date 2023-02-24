import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingStore {
  // 保存時のキー
  final String _saveKey = "Setting";

  // Switchバー
  bool toggle = false;

  // ストアのインスタンス
  static final SettingStore _instance = SettingStore._internal();

  // プライベートのコンストラクタ
  SettingStore._internal();

  // ファクトリーコンストラクタ
  factory SettingStore() {
    return _instance;
  }

  void changeToggle() {
    if (toggle) {
      toggle = false;
    } else {
      toggle = true;
    }
  }

  // 画面モードフラグを読み込み
  Future<void> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    toggle = prefs.getBool("isDarkTheme") ?? false;
  }
}
