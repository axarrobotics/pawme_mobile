import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_iot/wifi_iot.dart';

// --- Theme Colors matching Screenshot ---
const Color _backgroundColor = Color(0xFF0B121E); // Deep midnight blue
const Color _cardColor = Color(0xFF161D2B);       // Lighter navy for items
const Color _accentBlue = Color(0xFF007BFF);      // Vibrant blue for primary button
const Color _textSecondary = Color(0xFF9CA3AF);

class WifiGuidePage extends StatefulWidget {
  final String robotSSID;
  const WifiGuidePage({super.key, required this.robotSSID});

  @override
  State<WifiGuidePage> createState() => _WifiGuidePageState();
}

class _WifiGuidePageState extends State<WifiGuidePage> {
  List<WifiNetwork> _wifiList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _requestPermissionsAndScan();
  }

  Future<void> _requestPermissionsAndScan() async {
    var status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      _startScan();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is required for Wi-Fi scanning.')),
      );
    }
  }

  Future<void> _startScan() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _wifiList = [];
    });
    try {
      final results = await WiFiForIoTPlugin.loadWifiList();
      if (mounted) {
        setState(() {
          _wifiList = results
              .where((r) => r.ssid != null && r.ssid!.isNotEmpty)
              .toList();
          _wifiList.sort((a, b) => (b.level ?? -100).compareTo(a.level ?? -100));
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _connectToWifi(WifiNetwork wifi) async {
    String ssid = wifi.ssid ?? '';
    if (ssid.isEmpty) return;

    // Simple password prompt logic remains the same
    final password = await _showPasswordDialog(context, ssid) ?? '';
    if (password.isEmpty && (wifi.capabilities?.contains('WPA') ?? false)) return;

    try {
      final success = await WiFiForIoTPlugin.connect(ssid, password: password, joinOnce: true);
      if (mounted && success) {
        Navigator.of(context).pop(ssid);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Connection error: $e')));
    }
  }

  Future<String?> _showPasswordDialog(BuildContext context, String ssid) {
    final TextEditingController passwordController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor,
        title: Text('Connect to $ssid', style: const TextStyle(color: Colors.white)),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(hintText: 'Password', hintStyle: TextStyle(color: _textSecondary)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, passwordController.text), child: const Text('Connect')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor, //
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Back', style: TextStyle(color: Colors.white, fontSize: 12)),
        ),
        leadingWidth: 100,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // 1. Centered Header
              const Text(
                'Connect Robot',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Follow the steps to pair your device',
                style: TextStyle(color: _textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 24),

              // 2. Step Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStep(true),
                  const SizedBox(width: 8),
                  _buildStep(false),
                  const SizedBox(width: 8),
                  _buildStep(false),
                ],
              ),
              const SizedBox(height: 40),

              // 3. Wi-Fi Icon and Label
              const CircleAvatar(
                radius: 35,
                backgroundColor: _accentBlue,
                child: Icon(Icons.wifi, color: Colors.white, size: 35),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select WIFI Network',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              // 4. Stylized Wi-Fi List
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: _accentBlue))
                    : ListView.builder(
                  itemCount: _wifiList.length,
                  itemBuilder: (context, index) {
                    final wifi = _wifiList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: InkWell(
                        onTap: () => _connectToWifi(wifi),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                          decoration: BoxDecoration(
                            color: _cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withOpacity(0.05)),
                          ),
                          child: Text(
                            wifi.ssid ?? 'Unknown',
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 5. Continue Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Continue', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(bool isActive) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.cyanAccent : Colors.white24,
      ),
    );
  }
}
