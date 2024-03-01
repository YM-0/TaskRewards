import 'package:flutter/material.dart';
import 'package:task_rewards/services/admob.dart';
import 'package:task_rewards/src/store/theme_store.dart';
import 'package:task_rewards/src/view/home_page.dart';
import 'package:task_rewards/src/view/task/task_page.dart';
import 'package:task_rewards/src/view/reward/reward_page.dart';
import 'package:task_rewards/src/view/history_page.dart';
import 'package:task_rewards/src/model/database_helper.dart';
import 'package:provider/provider.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();
  SharedPreferences prefs = await SharedPreferences.getInstance();
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
