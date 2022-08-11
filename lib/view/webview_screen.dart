import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_buy_list/config/app_theme.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share_buy_list/config/config.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key, required this.title, required this.url})
      : super(key: key);
  final String title;
  final String url;

  @override
  State<WebViewScreen> createState() => _WebViewState();
}

class _WebViewState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = AndroidWebView();
    } else if (Platform.isIOS) {
      WebView.platform = CupertinoWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageKey = Config.getLanguageKey();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.background,
        iconTheme: const IconThemeData(color: AppTheme.textDark),
        toolbarHeight: 50,
        title: Text(widget.title),
      ),
      body: WebView(
        initialUrl: widget.url.isNotEmpty
            ? widget.url
            : 'https://ychof.com/share_buy_list/404?lang=$languageKey',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}