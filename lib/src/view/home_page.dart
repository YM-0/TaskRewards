import 'package:flutter/material.dart';
import 'package:management/main.dart';
import 'package:management/src/store/total_point_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ポイントストアクラス
  final TotalPointStore _pointStore = TotalPointStore();
  @override

  // 初期処理を行う
  void initState() {
    super.initState();

    Future(() async {
      _pointStore.load();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      body: Container(
        alignment: Alignment(0.0, 0.0),
        child: Text(
          // 現在のポイント表示
          _pointStore.totalPoint.toString(),
        ),
      ),
    );
  }
}
