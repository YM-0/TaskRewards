import 'package:flutter/material.dart';
import 'package:management/services/admob.dart';
import 'package:management/src/store/theme_store.dart';
import 'package:management/src/view/history_page.dart';
import 'package:management/src/view/home_page.dart';
import 'package:management/src/view/reward/reward_page.dart';
import 'package:management/src/view/task/task_page.dart';
import 'package:management/src/model/database_helper.dart';
import 'package:provider/provider.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Admob.initialize();
  return runApp(ChangeNotifierProvider(
    child: const MyApp(),
    create: (context) => ThemeProvider(
      isDarkMode: prefs.getBool("isDarkTheme") ?? false,
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return MaterialApp(
        title: "TaskRewards",
        theme: themeProvider.getTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates, // 追加
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Navigation(),
      );
    });
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

  final dbhelper = DatabaseHelper.instance;

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
      bottomNavigationBar: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            AdmobBanner(
              adUnitId: AdMobService().getBannerAdUnitId(),
              adSize: AdmobBannerSize(
                width: MediaQuery.of(context).size.width.toInt(),
                height: AdMobService().getHeight(context).toInt(),
                name: 'SMART_BANNER',
              ),
            ),
            NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) => setState(() {
                _currentIndex = index;
              }),
              // ナビゲーションの設定
              destinations: [
                NavigationDestination(
                  selectedIcon: const Icon(Icons.home),
                  icon: const Icon(Icons.home_outlined),
                  label: AppLocalizations.of(context).home,
                ),
                NavigationDestination(
                  selectedIcon: const Icon(Icons.description),
                  icon: const Icon(Icons.description_outlined),
                  label: AppLocalizations.of(context).task,
                ),
                NavigationDestination(
                  selectedIcon: const Icon(Icons.emoji_events),
                  icon: const Icon(Icons.emoji_events_outlined),
                  label: AppLocalizations.of(context).reward,
                ),
                NavigationDestination(
                  selectedIcon: const Icon(Icons.calendar_month),
                  icon: const Icon(Icons.calendar_month_outlined),
                  label: AppLocalizations.of(context).history,
                ),
              ],
            ),
          ]),
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