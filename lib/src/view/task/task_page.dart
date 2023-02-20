import 'package:flutter/material.dart';
import 'package:management/src/model/item_model.dart';
import 'package:management/src/store/history_store.dart';
import 'package:management/src/store/task_list_store.dart';
import 'package:management/src/view/task/task_input_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management/src/store/point_store.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

// Taskリスト表示
// Taskの追加/編集画面へ遷移
// Taskの削除

class _TaskPageState extends State<TaskPage> {
  // ストアクラス
  final TaskListStore _taskStore = TaskListStore();
  final TotalPointStore _pointStore = TotalPointStore();
  final HistoryStore _historyStore = HistoryStore();

  String model = "Task";

  // Taskリスト入力画面に遷移する
  void _pushTaskInputPage([Item? task]) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return TaskInputPage(task: task);
      }),
    );
    await _taskStore.get();
    // 画面更新
    setState(() {});
    if (task != null) {
      Navigator.of(context).pop();
    }
  }

  // 初期処理を行う
  @override
  void initState() {
    super.initState();

    Future(
      () async {
        // ストアからTaskリストデータをロードし、画面を更新する
        await _taskStore.get();
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  // ボトムシートを表示
  void _showModalBottomSheet(Item item) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        builder: (BuildContext context) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            height: MediaQuery.of(context).size.height * 0.4, // Sheetの高さ
            padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(item.color),
                      ),
                      height: 30,
                      width: 30,
                    ),
                    Flexible(
                      child: Text(
                        item.name,
                        style: GoogleFonts.oswald(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                      height: 50,
                      width: 50,
                      child: Card(
                        shape: const RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.grey, //色
                              width: 0.5, //太さ
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        elevation: 5,
                        child: InkWell(
                          onTap: () {
                            _pushTaskInputPage(item);
                          },
                          child: const Icon(
                            Icons.edit,
                            color: Colors.yellow,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                      height: 70,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Card(
                        shape: const RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.grey, //色
                              width: 0.5, //太さ
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        elevation: 5,
                        child: Center(
                          child: Text(
                            item.point.toString() + " P",
                            style: GoogleFonts.roboto(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                      height: 50,
                      width: 50,
                      child: Card(
                        shape: const RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.grey, //色
                              width: 0.5, //太さ
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        elevation: 5,
                        child: InkWell(
                          onTap: () async {
                            await _taskStore.delete(item);
                            await _taskStore.get();
                            setState(() {
                              Navigator.of(context).pop();
                            });
                          },
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      _pointStore.plus(item.point);
                      _historyStore.insert(item, model);
                      Fluttertoast.showToast(
                        msg: 'タスク完了\n${item.point}ポイント獲得',
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Text("ポイント獲得"),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "キャンセル",
                      style: TextStyle(color: Colors.black),
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
        title: const Text("TASK"),
      ),
      // リスト一覧表示(並び替え可能にするためReorderableListView使用)
      body: ReorderableListView.builder(
        // 並び替え用
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final Item item = _taskStore.list.removeAt(oldIndex);
            _taskStore.list.insert(newIndex, item);
          });
          _taskStore.saveSort();
        },
        // Taskの件数をリストの件数とする
        itemCount: _taskStore.count(),
        itemBuilder: (context, index) {
          // インデックスに対応するTaskを取得する
          var item = _taskStore.findByIndex(index);
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
              // 色
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
              // ボトムシートを表示
              onTap: () {
                _showModalBottomSheet(item);
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _pushTaskInputPage,
        child: const Icon(Icons.add),
      ),
    );
  }
}
