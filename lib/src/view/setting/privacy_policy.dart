import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State {
  late final WebViewController _controller;

  // ignore: prefer_typing_uninitialized_variables
  var connectionStatus;

  int position = 1;
  final key = UniqueKey();

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: startLoading,
          onPageFinished: doneLoading,
        ),
      )
      ..loadRequest(Uri.parse(
          'https://www.freeprivacypolicy.com/live/15ec9c3d-dec6-42be-89ff-1bf7d5611cb5'));
  }

  doneLoading(String A) {
    setState(() {
      position = 0;
    });
  }

  startLoading(String A) {
    setState(() {
      position = 1;
    });
  }

  // インターネット接続チェック
  Future check() async {
    try {
      final result = await InternetAddress.lookup('freeprivacypolicy.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connectionStatus = true;
      }
    } on SocketException catch (_) {
      connectionStatus = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: check(), // Future or nullを取得
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context).privacyPolicyPage),
            ),
            body: connectionStatus == true
                ? IndexedStack(
                    index: position,
                    children: [
                      WebViewWidget(
                        controller: _controller,
                      ),
                      // プログレスインジケーターを表示
                      const Center(
                        child: CircularProgressIndicator(
                            backgroundColor: Colors.blue),
                      ),
                    ],
                  )
                // インターネットに接続されていない場合の処理
                : SafeArea(
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 120,
                              bottom: 20,
                            ),
                            child: Container(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 20,
                            ),
                            child: Text(
                              AppLocalizations.of(context).connectionError,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        });
  }
}
