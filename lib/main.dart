import 'package:flutter/material.dart';
import 'package:management/src/view/data_page.dart';
import 'package:management/src/view/home_page.dart';
import 'package:management/src/view/reward/reward_page.dart';
import 'package:management/src/view/task/task_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const Navigation(),
    );
  }
}

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  // ページ選択用のインデックス
  int _currentIndex = 0;

  // 表示するページ
  List<Widget> pages = [
    const HomePage(),
    const TaskPage(),
    const RewardPage(),
    const DataPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: pages[_currentIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() {
          _currentIndex = index;
        }),
        // ナビゲーションの設定
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.description),
            icon: Icon(Icons.description_outlined),
            label: 'Task',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.emoji_events),
            icon: Icon(Icons.emoji_events_outlined),
            label: 'Reward',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.leaderboard),
            icon: Icon(Icons.leaderboard_outlined),
            label: 'Data',
          ),
        ],
      ),
    );
  }
}


/// 11/1 
/// 下記urlを参考にTaskモデルを作成。
/// task_list_storeを作成すべし。また、それに応じた改良を加える。
/// https://qiita.com/i-tanaka730/items/ee5a58ce9a9d7774feaa#4-4-todo_list_storedart

/// 11/2
/// task_list_store作成
/// ModalBottomBarかList形式でデータを受け取ることに成功。

/// 11/3
/// リストタイルカスタム
/// https://www.mechengjp.com/%E3%80%90flutter%E3%80%91listtile%E3%81%AE%E9%AB%98%E3%81%95%E3%82%84%E6%9E%A0%E7%B7%9A%E3%81%AA%E3%81%A9%E3%81%AE%E3%82%AB%E3%82%B9%E3%82%BF%E3%83%A0%E6%96%B9%E6%B3%95%E3%81%BE%E3%81%A8%E3%82%81/

/// 11/5
/// ・expensionの例外を解消
/// setState内の_store.load()を別々に記載したら直った。なんで。
/// ・cardアイコン部分の試行錯誤
/// 色選択にするか頑張ってIconにするか。
/// 色選択実装。