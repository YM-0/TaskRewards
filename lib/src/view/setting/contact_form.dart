import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContactForm extends StatefulWidget {
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State {
  late final WebViewController _controller;

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
          'https://docs.google.com/forms/d/e/1FAIpQLSfje9gUA4ruQs_ZT-KQ80MHcNd5HpythK1CCQ2fzcoWYnxHMA/viewform'));
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
      final result = await InternetAddress.lookup('google.com');
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
              title: const Text('お問い合わせ'),
            ),
            body: connectionStatus == true
                ? IndexedStack(
                    index: position,
                    children: [
                      WebViewWidget(
                        controller: _controller,
                      ),
                      // プログレスインジケーターを表示
                      Container(
                        child: const Center(
                          child: CircularProgressIndicator(
                              backgroundColor: Colors.blue),
                        ),
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
                            padding: EdgeInsets.only(
                              bottom: 20,
                            ),
                            child: Text(
                              'インターネットに接続されていません',
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
