import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:management/src/model/list_model.dart';
import 'dart:convert';

class DataStore {
  // 保存時のキー
  final String _saveKey = "events";

  // イベントマップリスト
  Map<DateTime, List<Item>> eventsList = {};

  // カウント用
  int totalTask = 0;
  int totalReward = 0;
  int monthTask = 0;
  int monthReward = 0;

  // ストアのインスタンス
  static final DataStore _instance = DataStore._internal();

  // プライベートコンストラクタ
  DataStore._internal();

  // ファクトリーコンストラクタ
  // (インスタンスを生成しないコンストラクタのため、自分でインスタンスを生成する)
  factory DataStore() {
    return _instance;
  }

  // DateTime型から8桁のint型へ変換
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month + 10000 + key.year;
  }

  void countTotal() {
    totalTask = 0;
    totalReward = 0;
    eventsList.forEach((key, value) {
      eventsList[key]!.forEach((element) {
        if (element.model == "Task") {
          totalTask += 1;
        } else if (element == "Reward") {
          totalReward += 1;
        }
      });
    });
  }

  // 今週のタスク、リワード数をカウントする
  void countMonth() {
    monthTask = 0;
    monthReward = 0;
    var month = DateTime.now().month;
    eventsList.forEach((key, value) {
      var eventMonth = key.month;
      if (eventMonth == month) {
        eventsList[key]!.forEach((element) {
          if (element.model == "Task") {
            monthTask += 1;
          } else if (element.model == "Reward") {
            monthReward += 1;
          }
        });
      }
    });
  }

  // Mapの要素をStringへ変換 (Map<DateTime, List> → Map<String, StringList>)
  static Map<String, List> encodeMap(Map<DateTime, List<Item>> map) {
    Map<String, List> newMap = {}; // map用意
    // mapの各組み合わせに一回ずつ処理を実行
    map.forEach((key, value) {
      // mapのValueをString型にしてnewMapに格納
      newMap[key.toString()] =
          // keyに対応するList内の要素をstringに変換
          map[key]!.map((a) => json.encode(a.toJson())).toList();
    });
    return newMap;
  }

  static Map<DateTime, List<Item>> decodeMap(Map<String, List> map) {
    Map<DateTime, List<Item>> newMap = {}; // map用意
    // mapの各組み合わせに一回ずつ処理を実行
    map.forEach((key, value) {
      // mapのstringをDateTimeに変換
      newMap[DateTime.parse(key)] =
          // keyに対応するList内の要素をDecode
          map[key]!.map((a) => Item.fromJson(json.decode(a))).toList();
    });
    return newMap;
  }

  // 日付をKeyとしてMapへリストを追加
  void add(Item item) {
    var now = DateTime.now();
    var date = DateTime(now.year, now.month, now.day);
    List<Item> list = [item];
    if (eventsList[date] == null) {
      //eventsList[date].add(item);
      eventsList[date] = list;
    } else {
      eventsList[date]?.add(item);
    }
    print(eventsList);
    save();
    print("追加");
  }

  // Mapを保存する
  void save() async {
    var prefs = await SharedPreferences.getInstance();
    // SharedPreferencesはプリミティブ型とString型リストしか扱えないため、以下の変換を行っている
    // Map<DateTime, List<dynamic>> → Map<string, List<json>> → List<Map> → JsonList
    var StringMap = encodeMap(eventsList);
    // Map<string, List<string>>をList<String(Json)>に変換
    List<String> saveTarget = [];
    saveTarget.add(json.encode(StringMap));
    prefs.setStringList(_saveKey, saveTarget);
    print("セーブ ");
  }

  //Mapを読み込みする
  void load() async {
    var prefs = await SharedPreferences.getInstance();
    // SharedPreferencesはプリミティブ型とString型リストしか扱えないため、以下の変換を行っている
    // StringList形式 → JSON形式 → MAP形式 → TodoList形式
    var loadTarget = prefs.getStringList(_saveKey) ?? [];
    // String(json)をMapに変換
    if (loadTarget.isEmpty == false) {
      Map<String, List> map =
          Map<String, List>.from(json.decode(loadTarget[0]));
      // Map<string, List<string>>をMap<DateTime, List<Task>>に変換
      eventsList = decodeMap(map);
    }

    print("イベントロード");
  }
}
