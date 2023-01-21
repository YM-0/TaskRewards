import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:management/src/model/task.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:management/src/store/reward_list_store.dart';

/// Todo入力画面のクラス
///
/// 以下の責務を持つ
/// ・Todo入力画面の状態を生成する
class RewardInputPage extends StatefulWidget {
  /// Todoのモデル
  final Task? reward;

  /// コンストラクタ
  /// Todoを引数で受け取った場合は更新、受け取らない場合は追加画面となる
  const RewardInputPage({Key? key, this.reward}) : super(key: key);

  /// Todo入力画面の状態を生成する
  @override
  State<RewardInputPage> createState() => _RewardInputPageState();
}

/// Todo入力ト画面の状態クラス
///
/// 以下の責務を持つ
/// ・Todoを追加/更新する
/// ・Todoリスト画面へ戻る
class _RewardInputPageState extends State<RewardInputPage> {
  /// ストア
  final RewardeListStore _store = RewardeListStore();

  /// 新規追加か
  late bool _isCreateTask;

  /// 画面項目：名前
  late String _name;

  /// 画面項目：ポイント
  late int _point;

  /// 画面項目：カラー
  late int _color;
  late Color selectedColor = Colors.red;
  late Color pickerColor = Colors.red;

  /// 初期処理を行う
  @override
  void initState() {
    super.initState();
    var reward = widget.reward;

    _name = reward?.name ?? "";
    _point = reward?.point ?? 0;
    _color = reward?.color ?? Colors.red.value;
    _isCreateTask = reward == null;
  }

  // color変更
  void _changeColor(Color color) {
    pickerColor = color;
  }

  // colorPicker表示
  void _showPicker(BuildContext context) {
    showDialog(
      builder: (context) => AlertDialog(
        title: const Text("Color選択"),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: pickerColor,
            onColorChanged: _changeColor,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text("決定"),
            onPressed: () {
              setState(() => selectedColor = pickerColor);
              _color = selectedColor.value;
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      context: context,
    );
  }

  /// 画面を作成する
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // アプリケーションバーに表示するタイトル
        title: Text(_isCreateTask ? 'Todo追加' : 'Todo更新'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        padding: EdgeInsets.all(40),
        child: Column(
          children: <Widget>[
            // 色選択用Container
            InkWell(
              onTap: () {
                _showPicker(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedColor,
                ),
                height: 50,
                width: 50,
              ),
            ),
            // タスク名入力用TextField
            TextField(
              decoration: const InputDecoration(
                hintText: "報酬名を入力してください",
                labelText: "Reward",
              ),
              maxLength: 20,
              maxLengthEnforcement:
                  MaxLengthEnforcement.truncateAfterCompositionEnds,
              // 入力されたテキストを変数に格納
              controller: TextEditingController(text: _name),
              onChanged: (String value) {
                _name = value;
                //setState(() {});
              },
            ),
            // ポイント設定用TextField
            TextField(
              decoration: const InputDecoration(
                hintText: "ポイントを設定してください",
                labelText: "Point",
              ),
              maxLength: 5,
              maxLengthEnforcement:
                  MaxLengthEnforcement.truncateAfterCompositionEnds,
              // 数字しか入力できないようにする
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              // 入力されたテキストを変数に格納
              onChanged: (String value) {
                if (value == "") {
                  _point = 0;
                } else {
                  _point = int.parse(value);
                }
                //setState(() {});
              },
            ),

            const SizedBox(height: 8),
            // リスト追加ボタン
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_name != "") {
                    if (_isCreateTask) {
                      // Taskを追加する
                      _store.add(_name, _point, _color);
                    } else {
                      // Taskを更新する
                      _store.update(widget.reward!, _name, _point, _color);
                    }
                    // Taskリスト画面に戻る
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  _isCreateTask ? "報酬追加" : "報酬更新",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            // キャンセルボタン
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "キャンセル",
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
