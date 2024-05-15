import 'package:flutter/material.dart';

// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WebViewExample(),
    );
  }
}

class WebViewExample extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  bool _isFirstLoad = true;



  @override
  Widget build(BuildContext context) {
    var webviewController = WebViewController();
    webviewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if(_isFirstLoad){
              webviewController.runJavaScript('flutterLocation(1,3)');
              _isFirstLoad = false;
            }
          }
        )
      )
      ..loadRequest(Uri.parse('http://172.30.1.19:3000'));

    return SafeArea(child: WebViewWidget(controller: webviewController));
  }
}
