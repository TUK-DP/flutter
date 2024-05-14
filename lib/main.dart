import 'package:flutter/material.dart';
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
  bool enable = await checkLocationService();
  if (enable) {
    runApp(MyApp());
  } else {
    runApp(LocationErrorApp());
  }
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
  @override
  Widget build(BuildContext context) {
    var controller = WebViewController();
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    /**
     * // initialUrl: 'http://192.168.61.207:3000',
        // initialUrl: 'https://remomory.shop',
        initialUrl: 'https://twoone14.shop/location',
        javascriptMode: JavascriptMode.unrestricted,
     */
    controller.loadRequest(Uri.parse("https://twoone14.shop/location"));
    return Scaffold(
      body: SafeArea(child: WebViewWidget(controller: controller)),
    );
  }
}

class LocationErrorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child:
              Text('Location services are disabled or permissions are denied.'),
        ),
      ),
    );
  }
}
