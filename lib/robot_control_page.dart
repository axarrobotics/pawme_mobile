import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart'; // Import is correct

// 1. Convert to StatefulWidget
class RobotControlPage extends StatefulWidget {
  final String robotUrl;
  const RobotControlPage({super.key, required this.robotUrl});

  @override
  State<RobotControlPage> createState() => _RobotControlPageState();
}

class _RobotControlPageState extends State<RobotControlPage> {
  // 2. Declare the WebViewController
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    // 3. Initialize and configure the controller
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Replaces JavascriptMode.unrestricted
      ..loadRequest(Uri.parse(widget.robotUrl)); // Loads the initial URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Robot Control Panel')),
      // 4. Use the new WebViewWidget
      body: WebViewWidget(controller: controller),
    );
  }
}