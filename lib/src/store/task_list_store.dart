import 'package:management/src/model/item_model.dart';
import 'package:management/src/model/database_helper.dart';

// TaskStoreクラス
// Taskを取得/追加/更新/削除/保存/読み込み
class TaskListStore {
  // Taskリスト
  List<Item> list = [];

  // インスタンス
  static final TaskListStore _instance = TaskListStore._internal();
  final dbhelper = DatabaseHelper.instance;

  // プライベートコンストラクタ
  TaskListStore._internal();

  // ファクトリーコンストラクタ
  // (インスタンスを生成しないコンストラクタのため、自分でインスタンスを生成する)
  factory TaskListStore() {
    return _instance;
  }

  // Taskの件数を取得
  int count() {
    return list.length;
  }

  // 指定したインデックスのTaskを取得
  Item findByIndex(int index) {
    return list[index];
  }

  // Taskを更新
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
    dbhelper.updateTask(task);
  }

  // Taskを削除
  Future<void> delete(Item task) async {
    await dbhelper.deleteTask(task.id);
  }

  // Taskを登録
  Future<void> insert(String name, int point, int color) async {
    var id = count() == 0 ? 1 : list.last.id + 1;
    var sort = count() == 0 ? 0 : list.last.sort;
    var task = Item(id, name, point, color, sort);
    await dbhelper.insertTask(task);
  }

  // Taskを取得
  Future<void> get() async {
    list = await dbhelper.getTask();
    // 保存済みの順番でソート
    list.sort((a, b) => a.sort.compareTo(b.sort));
  }

  // 並び順を保存
  Future<void> saveSort() async {
    list.asMap().forEach((index, item) {
      item.sort = index;
      dbhelper.updateTask(item);
    });
  }
}
