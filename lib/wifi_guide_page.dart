import 'package:flutter/material.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:permission_handler/permission_handler.dart';

class WifiGuidePage extends StatefulWidget {
  const WifiGuidePage({super.key});

  @override
  _WifiGuidePageState createState() => _WifiGuidePageState();
}

class _WifiGuidePageState extends State<WifiGuidePage> {
  List<WiFiAccessPoint>? _wifiList;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _requestPermissionsAndScan();
  }

  Future<void> _requestPermissionsAndScan() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _startScan();
    } else {
      setState(() {
        _wifiList = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _startScan() async {
    final canScanResult = await WiFiScan.instance.canStartScan();

    if (canScanResult != CanStartScan.yes) {
      setState(() {
        _wifiList = [];
        _isLoading = false;
      });
      return;
    }

    WiFiScan.instance.startScan();

    WiFiScan.instance.onScannedResultsAvailable.listen((results) {
      setState(() {
        _wifiList = results;
        _isLoading = false;
      });
    });
  }

  Future<void> _connectToWifi(String ssid, String? password, NetworkSecurity security) async {
    try {
      print('Attempting Wi-Fi connection to $ssid');
      bool success = await WiFiForIoTPlugin.connect(
        ssid,
        password: password,
        security: security,
        joinOnce: true,
      );
      print(success ? 'Connected successfully' : 'Failed to connect');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? "Connected to $ssid" : "Failed to connect")),
      );
    } catch (e) {
      print('Exception connecting to WiFi: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error connecting to WiFi: $e')),
      );
    }
  }



  void _onNetworkTap(WiFiAccessPoint wifi) {
    if (wifi.capabilities.contains('WPA') || wifi.capabilities.contains('WEP')) {
      showDialog(
        context: context,
        builder: (context) {
          final passwordController = TextEditingController();
          return AlertDialog(
            title: Text('Connect to ${wifi.ssid}'),
            content: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _connectToWifi(
                    wifi.ssid,
                    passwordController.text,
                    wifi.capabilities.contains('WPA')
                        ? NetworkSecurity.WPA
                        : NetworkSecurity.WEP,
                  );
                },
                child: const Text('Connect'),
              ),
            ],
          );
        },
      );
    } else {
      _connectToWifi(wifi.ssid, null, NetworkSecurity.NONE);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Wi-Fi Networks')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _wifiList == null || _wifiList!.isEmpty
              ? const Center(child: Text('No Wi-Fi networks found'))
              : ListView.builder(
                  itemCount: _wifiList!.length,
                  itemBuilder: (context, index) {
                    final wifi = _wifiList![index];
                    return ListTile(
                      title: Text(wifi.ssid),
                      subtitle: Text('Signal strength: ${wifi.level}'),
                      trailing: wifi.capabilities.contains('WPA') || wifi.capabilities.contains('WEP')
                          ? const Icon(Icons.lock)
                          : const Icon(Icons.lock_open),
                      onTap: () => _onNetworkTap(wifi),
                    );
                  },
                ),
    );
  }
}
