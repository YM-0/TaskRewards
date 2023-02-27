import 'package:flutter/material.dart';
import 'package:management/src/store/history_store.dart';
import 'package:management/src/model/item_model.dart';
import 'package:management/src/store/reward_list_store.dart';
import 'package:management/src/view/reward/reward_input_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management/src/store/point_store.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  final TotalPointStore _pointStore = TotalPointStore();
  final HistoryStore _historyStore = HistoryStore();

  String model = "Reward";

  // Taskリスト入力画面に遷移する
  void _pushRewardInputPage([Item? reward]) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return RewardInputPage(reward: reward);
      }),
    );
    // 画面更新
    await _rewardStore.get();
    setState(() {});
    if (reward != null) {
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
        await _rewardStore.get();
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

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
                            _pushRewardInputPage(item);
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
                            await _rewardStore.delete(item);
                            await _rewardStore.get();
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
                      if ((_pointStore.totalPoint - item.point) >= 0) {
                        _pointStore.minus(item.point);
                        _historyStore.insert(item, model);
                        Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)
                              .rewardToast(item.point),
                        );
                      } else {
                        Fluttertoast.showToast(
                            msg: AppLocalizations.of(context).rewardErrorToast,
                            backgroundColor:
                                const Color.fromARGB(250, 60, 60, 60));
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text(AppLocalizations.of(context).gainRewards),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      AppLocalizations.of(context).cancel,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 37, 36, 36)),
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
        centerTitle: true,
        title: Text(AppLocalizations.of(context).rewardPage),
      ),
      // リスト一覧表示(並び替え可能にするためReorderableListView使用)
      body: ReorderableListView.builder(
        // 並び替え用
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final Item item = _rewardStore.list.removeAt(oldIndex);
            _rewardStore.list.insert(newIndex, item);
          });
          _rewardStore.saveSort();
        },
        // Rewardの件数をリストの件数とする
        itemCount: _rewardStore.count(),
        itemBuilder: (context, index) {
          // インデックスに対応するRewardを取得する
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
