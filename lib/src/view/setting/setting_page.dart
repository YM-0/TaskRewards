import 'package:flutter/material.dart';
import 'package:task_rewards/src/store/setting_store.dart';
import 'package:task_rewards/src/store/theme_store.dart';
import 'package:task_rewards/src/view/setting/contact_form.dart';
import 'package:task_rewards/src/view/setting/privacy_policy.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:task_rewards/src/store/history_store.dart';
import 'package:task_rewards/src/store/point_store.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        resetName = AppLocalizations.of(context).pointText;
        break;
      case 2:
        resetName = AppLocalizations.of(context).historyText;
        break;
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context).confirm),
            content: Text(AppLocalizations.of(context).resetMessage(resetName)),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context).cancel)),
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
                        msg: AppLocalizations.of(context).resetToast(resetName),
                        backgroundColor: const Color.fromARGB(250, 60, 60, 60));
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context).ok))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context).settingPage),
      ),
      body: SafeArea(
          child: SettingsList(
        sections: [
          SettingsSection(
            title: Text(AppLocalizations.of(context).displayMode),
            tiles: [
              SettingsTile.switchTile(
                title: Text(AppLocalizations.of(context).darkMode),
                leading: const Icon(Icons.settings_display),
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
            title: Text(AppLocalizations.of(context).reset),
            tiles: [
              SettingsTile(
                title: Text(AppLocalizations.of(context).pointReset),
                leading: const Icon(Icons.restore),
                onPressed: (context) {
                  _resetDialog(1);
                },
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context).historyReset),
                leading: const Icon(Icons.restore),
                onPressed: (context) {
                  _resetDialog(2);
                },
              )
            ],
          ),
          SettingsSection(
            title: Text(AppLocalizations.of(context).contact),
            tiles: [
              SettingsTile(
                title: Text(AppLocalizations.of(context).inquiry),
                leading: const Icon(Icons.contact_page),
                onPressed: (context) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const ContactForm();
                  }));
                },
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context).privacyPolicy),
                leading: const Icon(Icons.privacy_tip),
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
