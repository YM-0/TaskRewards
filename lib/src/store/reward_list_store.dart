import 'package:management/src/model/item_model.dart';
import 'package:management/src/model/database_helper.dart';

// RewardStoreクラス
// Rewardを取得/追加/更新/削除/保存/読み込み
class RewardeListStore {
  // Taskリスト
  List<Item> list = [];

  // インスタンス
  static final RewardeListStore _instance = RewardeListStore._internal();
  final dbhelper = DatabaseHelper.instance;

  // プライベートコンストラクタ
  RewardeListStore._internal();

  // ファクトリーコンストラクタ
  // (インスタンスを生成しないコンストラクタのため、自分でインスタンスを生成する)
  factory RewardeListStore() {
    return _instance;
  }

  // Rewardの件数を取得
  int count() {
    return list.length;
  }

  // 指定したインデックスのRewardを取得
  Item findByIndex(int index) {
    return list[index];
  }

  // Rewardを更新
  Future<void> update(Item reward,
      [String? name, int? point, int? color]) async {
    if (name != null) {
      reward.name = name;
    }
    if (point != null) {
      reward.point = point;
    }
    if (color != null) {
      reward.color = color;
    }
    await dbhelper.updateReward(reward);
  }

  // Taskを削除する
  Future<void> delete(Item reward) async {
    await dbhelper.deleteReward(reward.id);
  }

  // Rewardを登録する
  Future<void> insert(String name, int point, int color) async {
    var id = count() == 0 ? 1 : list.last.id + 1;
    var sort = count() == 0 ? 0 : list.last.sort;
    var reward = Item(id, name, point, color, sort);
    await dbhelper.insertReward(reward);
  }

  // Rewardを取得
  Future<void> get() async {
    list = await dbhelper.getReward();
    // 保存済みの順番でソート
    list.sort((a, b) => a.sort.compareTo(b.sort));
  }

  // 並び順を保存
  Future<void> saveSort() async {
    list.asMap().forEach((index, item) {
      item.sort = index;
      dbhelper.updateReward(item);
    });
  }
}
