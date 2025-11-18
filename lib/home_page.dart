import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'wifi_guide_page.dart';
import 'sign_in_page.dart';
import 'robot_control_page.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _connectedToRobot = false;
  String _currentSSID = "";
  final TextEditingController _ipController =
  TextEditingController(text: 'http://192.168.4.1'); // Default IP

  @override
  void initState() {
    super.initState();
    _checkWifiConnection();
  }

  Future<void> _checkWifiConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.wifi) {
      final info = NetworkInfo();
      String? ssid = await info.getWifiName();
      setState(() {
        _currentSSID = ssid ?? "";
        _connectedToRobot = ssid == "ESP-CAM_MJPEG_9073F862F8B8"; // Replace with your robot's SSID
      });
    } else {
      setState(() {
        _connectedToRobot = false;
        _currentSSID = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await _googleSignIn.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignInPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: _connectedToRobot
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Connected to Robot Wi-Fi ($_currentSSID)'),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextField(
                controller: _ipController,
                decoration: const InputDecoration(
                  labelText: 'Robot Control IP',
                  hintText: 'http://192.168.4.1',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Go to Control Panel'),
              onPressed: () {
                String ip = _ipController.text.trim();
                if (ip.isNotEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RobotControlPage(robotUrl: ip),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Enter a valid IP!')),
                  );
                }
              },
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_currentSSID.isEmpty
                ? 'Device is not connected via Wi-Fi'
                : 'Device is connected to $_currentSSID'),
            const SizedBox(height: 24),
            ElevatedButton(
              child: const Text('Go to Wi-Fi Scanner'),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const WifiGuidePage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
