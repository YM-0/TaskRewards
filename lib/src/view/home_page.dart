import 'package:flutter/material.dart';
import 'package:management/src/store/history_store.dart';
import 'package:management/src/store/point_store.dart';
import 'package:management/src/view/setting/setting_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ポイントストアクラス
  final TotalPointStore _pointStore = TotalPointStore();
  final HistoryStore _historyStore = HistoryStore();

  void _pushSettingPage() async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const SettingPage();
    }));
    setState(() {});
  }

  @override
  // 初期処理を行う
  void initState() {
    super.initState();

    Future(() async {
      await _historyStore.get();
      _historyStore.countMonth();
      _historyStore.countTotal();
      _pointStore.load();
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("HOME"),
        actions: [
          IconButton(
              onPressed: () {
                _pushSettingPage();
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                elevation: 5,
                child: Center(
                  child: Column(children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                      child: const Text(
                        "保有ポイント",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 25),
                      child: Text(
                        _pointStore.totalPoint.toString() + " P",
                        style: const TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
            const Text(
              "今月",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Card(
                        elevation: 5,
                        child: Center(
                            child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 10, 100, 10),
                              child: const Text(
                                "Task",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              _historyStore.monthTask.toString(),
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                      )),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Card(
                        elevation: 5,
                        child: Center(
                            child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 10, 75, 10),
                              child: const Text(
                                "Reward",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              _historyStore.monthReward.toString(),
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                      )),
                ],
              ),
            ),
            const Text(
              "合計",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Card(
                        elevation: 5,
                        child: Center(
                            child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 10, 100, 10),
                              child: const Text(
                                "Task",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              _historyStore.totalTask.toString(),
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                      )),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Card(
                        elevation: 5,
                        child: Center(
                            child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 10, 75, 10),
                              child: const Text(
                                "Reward",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              _historyStore.monthReward.toString(),
                              style: const TextStyle(
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
