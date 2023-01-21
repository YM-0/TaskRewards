import 'dart:ffi';
import 'package:shared_preferences/shared_preferences.dart';

class TotalPointStore {
  // 保存時のキー
  final String _saveKey = "TotalPoint";

  // トータルポイント
  int totalPoint = 0;

  // ストアのインスタンス
  static final TotalPointStore _instance = TotalPointStore._internal();

  // プライベートのコンストラクタ
  TotalPointStore._internal();

  // ファクトリーコンストラクタ
  factory TotalPointStore() {
    return _instance;
  }

  // TotalPointに加算する
  void plus(int point) {
    totalPoint += point;
  }

  // TotalPointから減算する
  void minus(int point) {
    totalPoint -= point;
  }

  void save() async {
    var prefs = await SharedPreferences.getInstance();
    var saveTargetInt = totalPoint;
    prefs.setInt(_saveKey, saveTargetInt);
  }

  void load() async {
    var prefs = await SharedPreferences.getInstance();
    var loadTargetInt = prefs.getInt(_saveKey) ?? 0;
    totalPoint = loadTargetInt;
  }
}
