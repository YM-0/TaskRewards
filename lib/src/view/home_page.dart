import 'package:flutter/material.dart';
import 'package:management/main.dart';
import 'package:management/src/store/history_store.dart';
import 'package:management/src/store/point_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ポイントストアクラス
  final TotalPointStore _pointStore = TotalPointStore();
  final DataStore _dataStore = DataStore();
  @override

  // 初期処理を行う
  void initState() {
    super.initState();

    Future(() async {
      _dataStore.count();
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
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                color: Colors.white10,
                child: Center(
                  child: Column(children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 230, 35),
                      child: Text(
                        "保有ポイント",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      _pointStore.totalPoint.toString() + " P",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ]),
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  "今月",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          height: 120,
                          width: 180,
                          child: Card(
                            color: Colors.white10,
                            child: Center(
                                child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 100, 10),
                                  child: Text(
                                    "Task",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  _dataStore.taskMonth.toString(),
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                          )),
                      SizedBox(
                          height: 120,
                          width: 180,
                          child: Card(
                            color: Colors.white10,
                            child: Center(
                                child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 75, 10),
                                  child: Text(
                                    "Reward",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  _dataStore.rewardMonth.toString(),
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                          )),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              "合計",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      height: 120,
                      width: 180,
                      child: Card(
                        color: Colors.white10,
                        child: Center(
                            child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 100, 10),
                              child: Text(
                                "Task",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              _dataStore.taskMonth.toString(),
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                      )),
                  SizedBox(
                      height: 120,
                      width: 180,
                      child: Card(
                        color: Colors.white10,
                        child: Center(
                            child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 75, 10),
                              child: Text(
                                "Reward",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              _dataStore.rewardMonth.toString(),
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
