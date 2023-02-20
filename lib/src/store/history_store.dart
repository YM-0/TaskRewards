import 'package:management/src/model/item_model.dart';
import 'package:management/src/model/history_model.dart';
import 'package:management/src/model/database_helper.dart';

class HistoryStore {
  // イベントマップリスト
  Map<DateTime, List<History>> eventsList = {};
  List<History> list = [];

  // カウント用
  int totalTask = 0;
  int totalReward = 0;
  int monthTask = 0;
  int monthReward = 0;

  // インスタンス
  static final HistoryStore _instance = HistoryStore._internal();
  final dbhelper = DatabaseHelper.instance;

  // プライベートコンストラクタ
  HistoryStore._internal();

  // ファクトリーコンストラクタ
  // (インスタンスを生成しないコンストラクタのため、自分でインスタンスを生成する)
  factory HistoryStore() {
    return _instance;
  }

  // DateTime型から8桁のint型へ変換
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month + 10000 + key.year;
  }

  // 総合のタスク、リワード数をカウントする
  void countTotal() {
    totalTask = 0;
    totalReward = 0;
    eventsList.forEach((key, value) {
      for (var element in eventsList[key]!) {
        if (element.model == "Task") {
          totalTask += 1;
          // ignore: unrelated_type_equality_checks
        } else if (element == "Reward") {
          totalReward += 1;
        }
      }
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
        for (var element in eventsList[key]!) {
          if (element.model == "Task") {
            monthTask += 1;
          } else if (element.model == "Reward") {
            monthReward += 1;
          }
        }
      }
    });
  }

  // Historyをリセット
  void resetHistory() async {
    eventsList = {};
    totalTask = 0;
    totalReward = 0;
    monthTask = 0;
    monthReward = 0;
    await dbhelper.resetHistory();
  }

  // Historyを登録
  void insert(Item item, String model) async {
    var now = DateTime.now();
    var date = DateTime(now.year, now.month, now.day).toString();
    list = await dbhelper.getHistory();
    var id = list.isEmpty ? 1 : list.last.id + 1;
    var history = History(id, item.name, item.point, item.color, model, date);
    await dbhelper.insertHistory(history);
  }

  //Historyを読み込みする
  Future<void> get() async {
    list = await dbhelper.getHistory();
    // カレンダーにイベントとして表示するため、Map型に変換
    Map<DateTime, List<History>> newMap = {};
    for (var item in list) {
      bool flag = false;
      newMap.forEach((key, value) {
        // キーが存在している場合、そこにitemを入れる
        if (key == DateTime.parse(item.date)) {
          newMap[key]!.add(item);
          flag = true;
        }
      });
      // キーが存在していない場合、itemのdateをキーとする
      if (flag == false) {
        newMap[DateTime.parse(item.date)] = [];
        newMap[DateTime.parse(item.date)]!.add(item);
      }
    }
    eventsList = newMap;
  }
}
