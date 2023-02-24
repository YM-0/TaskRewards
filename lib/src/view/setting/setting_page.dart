import 'package:flutter/material.dart';
import 'package:management/src/store/setting_store.dart';
import 'package:management/src/store/theme_store.dart';
import 'package:management/src/view/setting/contact_form.dart';
import 'package:management/src/view/setting/privacy_policy.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:management/src/store/history_store.dart';
import 'package:management/src/store/point_store.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:management/main.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // ストアクラス
  final HistoryStore _historyStore = HistoryStore();
  final TotalPointStore _pointStore = TotalPointStore();
  final SettingStore _settingStore = SettingStore();

  @override
  void initState() {
    super.initState();

    Future(
      () async {
        // ストアからTaskリストデータをロードし、画面を更新する
        await _settingStore.load();
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  // リセット用ダイアログ
  _resetDialog(check) {
    String resetName = "";
    switch (check) {
      case 1:
        resetName = "ポイント";
        break;
      case 2:
        resetName = "履歴";
        break;
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("確認"),
            content: Text("$resetNameをリセットします。\nよろしいですか？"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    switch (check) {
                      case 1:
                        // 合計ポイント削除
                        _pointStore.reset();
                        break;
                      case 2:
                        // 履歴削除
                        _historyStore.resetHistory();
                        break;
                    }
                    Fluttertoast.showToast(
                      msg: "$resetNameをリセットしました",
                    );
                    Navigator.pop(context);
                  },
                  child: const Text("OK"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("SETTING"),
      ),
      body: SafeArea(
          child: SettingsList(
        sections: [
          SettingsSection(
            title: const Text("DisplayMode"),
            tiles: [
              SettingsTile.switchTile(
                title: const Text("ダークモード"),
                initialValue: _settingStore.toggle,
                onToggle: (value) {
                  ThemeProvider themeProvider =
                      Provider.of<ThemeProvider>(context, listen: false);
                  setState(() {
                    themeProvider.swapTheme();
                    _settingStore.changeToggle();
                  });
                },
              )
            ],
          ),
          SettingsSection(
            title: const Text("Reset"),
            tiles: [
              SettingsTile(
                title: const Text("ポイントリセット"),
                leading: const Icon(Icons.restore),
                onPressed: (context) {
                  _resetDialog(1);
                },
              ),
              SettingsTile(
                title: const Text("履歴リセット"),
                leading: const Icon(Icons.restore),
                onPressed: (context) {
                  _resetDialog(2);
                },
              )
            ],
          ),
          SettingsSection(
            title: const Text("contact"),
            tiles: [
              SettingsTile(
                title: const Text("お問い合わせ"),
                leading: const Icon(Icons.contact_page),
                onPressed: (context) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const ContactForm();
                  }));
                },
              ),
              SettingsTile(
                title: const Text("プライバシーポリシー"),
                leading: const Icon(Icons.contact_page),
                onPressed: (context) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const PrivacyPolicy();
                  }));
                },
              ),
            ],
          )
        ],
      )),
    );
  }
}
