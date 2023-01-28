import 'package:shared_preferences/shared_preferences.dart';
import 'package:management/src/model/list_model.dart';
import 'dart:convert';

// TaskStoreクラス
// Taskを取得/追加/更新/削除/保存/読み込み
class RewardeListStore {
  // 保存時のキー
  final String _saveKey = "Reward";

  // Taskリスト
  List<Item> list = [];

  // ストアのインスタンス
  static final RewardeListStore _instance = RewardeListStore._internal();

  // プライベートコンストラクタ
  RewardeListStore._internal();

  // ファクトリーコンストラクタ
  // (インスタンスを生成しないコンストラクタのため、自分でインスタンスを生成する)
  factory RewardeListStore() {
    return _instance;
  }

  // Taskの件数を取得する
  int count() {
    return list.length;
  }

  // 指定したインデックスのTaskを取得する
  Item findByIndex(int index) {
    return list[index];
  }

  // Taskを追加する
  void add(String name, int point, int color) {
    var model = "Reward";
    var id = count() == 0 ? 1 : list.last.id + 1;
    var task = Item(id, name, point, color, model);
    list.add(task);
    save();
  }

  // Taskを更新する
  void update(Item task, [String? name, int? point, int? color]) {
    if (name != null) {
      task.name = name;
    }
    if (point != null) {
      task.point = point;
    }
    if (color != null) {
      task.color = color;
    }
    save();
  }

  // Taskを削除する
  void delete(Item task) {
    list.remove(task);
    save();
  }

  // Taskを保存する
  void save() async {
    var prefs = await SharedPreferences.getInstance();
    // SharedPreferencesはプリミティブ型とString型リストしか扱えないため、以下の変換を行っている
    // TodoList形式 → Map形式 → JSON形式 → StrigList形式
    var saveTargetList = list.map((a) => json.encode(a.toJson())).toList();
    prefs.setStringList(_saveKey, saveTargetList);
  }

  //Taskを読み込みする
  void load() async {
    var prefs = await SharedPreferences.getInstance();
    // SharedPreferencesはプリミティブ型とString型リストしか扱えないため、以下の変換を行っている
    // StringList形式 → JSON形式 → MAP形式 → TodoList形式
    var loadTargetList = prefs.getStringList(_saveKey) ?? [];
    list = loadTargetList.map((a) => Item.fromJson(json.decode(a))).toList();
  }
}
