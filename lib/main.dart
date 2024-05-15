import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future<bool> checkLocationService() async {
  Location location = Location();
  bool serviceEnabled;
  PermissionStatus permissionGranted;

  // 위치 서비스 활성화 확인 및 요청
  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return false;
    }
  }

  // 위치 권한 확인 및 요청
  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return false;
    }
  }

  return true;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  var webviewController = WebViewController();
  late Timer _timer;
  bool isFirstLoad = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLocationService();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    webviewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(onPageFinished: (url) async {

        Position position = await Geolocator.getCurrentPosition();
        print("position: ${position.latitude}, ${position.longitude}");
        webviewController.runJavaScript(
            'flutterLocation(${position.latitude},${position.longitude})');

        Timer.periodic(const Duration(minutes: 1), (timer) async {
          Position position = await Geolocator.getCurrentPosition();
          print("position: ${position.latitude}, ${position.longitude}");
          webviewController.runJavaScript(
              'flutterLocation(${position.latitude},${position.longitude})');
        });

      }))
      ..loadRequest(Uri.parse('https://remomory.shop'));

    return SafeArea(child: WebViewWidget(controller: webviewController));
  }
}
