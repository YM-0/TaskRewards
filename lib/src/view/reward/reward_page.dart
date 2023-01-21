import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:management/main.dart';
import 'package:management/src/model/list_model.dart';
import 'package:management/src/store/reward_list_store.dart';
import 'package:management/src/view/reward/reward_input_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:management/src/store/point_store.dart';
import 'package:management/src/store/task_list_store.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RewardPage extends StatefulWidget {
  const RewardPage({Key? key}) : super(key: key);

  @override
  State<RewardPage> createState() => _RewardPageState();
}

// Taskリスト表示
// Taskの追加/編集画面へ遷移
// Taskの削除

class _RewardPageState extends State<RewardPage> {
  // ストアクラス
  final RewardeListStore _rewardStore = RewardeListStore();
  final TaskListStore _taskStore = TaskListStore();
  final TotalPointStore _pointStore = TotalPointStore();

  // Taskリスト入力画面に遷移する
  void _pushRewardInputPage([Task? reward]) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        print("リワード追加画面へ遷移");
        return RewardInputPage(reward: reward);
      }),
    );
    // 画面更新
    setState(() {});
  }

  // 初期処理を行う
  @override
  void initState() {
    super.initState();

    Future(
      () async {
        // ストアからTaskリストデータをロードし、画面を更新する
        _rewardStore.load();
        setState(() {});
        print("ロード");
      },
    );
  }

  void _showModalBottomSheet(Task item) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),

            height: 350, // Sheetの高さ
            padding: const EdgeInsets.all(50),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(item.color),
                      ),
                      height: 30,
                      width: 30,
                    ),
                    Text(
                      item.name,
                      style: GoogleFonts.oswald(fontSize: 18),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                  height: 70,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 212, 240, 167),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text(
                      item.point.toString() + " P",
                      style: GoogleFonts.roboto(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      print(item.point);
                      if ((_pointStore.totalPoint - item.point) >= 0) {
                        _pointStore.minus(item.point);
                        Fluttertoast.showToast(
                          msg: '報酬獲得\n${item.point}ポイント消費',
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: 'ポイントが足りません',
                        );
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Text("報酬獲得"),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "キャンセル",
                      style: TextStyle(color: Color.fromARGB(255, 37, 36, 36)),
                    ),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  ),
                ),
              ],
            ),
          );
        });
  }

  // 画面を作成
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TaskPage"),
      ),
      // リスト一覧表示(並び替え可能にするためReorderableListView使用)
      body: ReorderableListView.builder(
        // 並び替え用
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final Task item = _rewardStore.list.removeAt(oldIndex);
            _rewardStore.list.insert(newIndex, item);
          });
        },
        // Taskの件数をリストの件数とする
        itemCount: _rewardStore.count(),
        itemBuilder: (context, index) {
          // インデックスに対応するTaskを取得する
          var item = _rewardStore.findByIndex(index);
          return Card(
            // 並び替え用のKey設定
            key: Key(item.id.toString()),
            // デザイン
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            elevation: 5,
            shadowColor: Colors.black,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),

            child: ListTile(
              // ID
              //leading: Text(item.id.toString()),

              leading: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(item.color),
                ),
                width: 25,
              ),
              // 名前
              title: Text(
                item.name,
                style: GoogleFonts.oswald(fontSize: 18),
              ),
              // ポイント
              trailing: Wrap(children: [
                Text(
                  item.point.toString() + " P",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                //Icon(Icons.more_vert),
              ]),
              onTap: () {
                _showModalBottomSheet(item);
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _pushRewardInputPage,
        child: const Icon(Icons.add),
      ),
    );
  }
}
