import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:management/src/store/task_list_store.dart';
import 'package:management/src/model/item_model.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

/// Todo入力画面のクラス
///
/// 以下の責務を持つ
/// ・Todo入力画面の状態を生成する
class TaskInputPage extends StatefulWidget {
  /// Todoのモデル
  final Item? task;

  /// コンストラクタ
  /// Todoを引数で受け取った場合は更新、受け取らない場合は追加画面となる
  const TaskInputPage({Key? key, this.task}) : super(key: key);

  /// Todo入力画面の状態を生成する
  @override
  State<TaskInputPage> createState() => _TaskInputPageState();
}

/// Todo入力ト画面の状態クラス
///
/// 以下の責務を持つ
/// ・Todoを追加/更新する
/// ・Todoリスト画面へ戻る
class _TaskInputPageState extends State<TaskInputPage> {
  /// ストア
  final TaskListStore _store = TaskListStore();

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
    var task = widget.task;

    _name = task?.name ?? "";
    _point = task?.point ?? 0;
    _color = task?.color ?? Colors.red.value;
    _isCreateTask = task == null;
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
        centerTitle: true,
        title: Text(_isCreateTask ? 'Task追加' : 'Task更新'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(40),
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
                    color: Color(_color),
                  ),
                  height: 50,
                  width: 50,
                ),
              ),
              // タスク名入力用TextField
              TextField(
                decoration: const InputDecoration(
                  hintText: "タスク名を入力してください",
                  labelText: "Task",
                ),
                maxLength: 20,
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
                controller: TextEditingController(text: _point.toString()),
                // 入力されたテキストを変数に格納
                onChanged: (String value) {
                  if (value == "") {
                    _point = 0;
                  } else {
                    _point = int.parse(value);
                  }
                },
              ),

              const SizedBox(height: 8),
              // リスト追加ボタン
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_name != "") {
                      if (_isCreateTask) {
                        // Taskを追加する
                        _store.insert(_name, _point, _color);
                      } else {
                        // Taskを更新する
                        _store.update(widget.task!, _name, _point, _color);
                      }
                      if (_name != "") {
                        // Taskリスト画面に戻る
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: Text(
                    _isCreateTask ? "タスク追加" : "タスク更新",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              // キャンセルボタン
              SizedBox(
                width: double.infinity,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
