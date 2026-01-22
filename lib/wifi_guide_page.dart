import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'constants/app_colors.dart';
import 'screens/home_page.dart';

class WifiGuidePage extends StatefulWidget {
  final String robotSSID;
  const WifiGuidePage({super.key, required this.robotSSID});

  @override
  State<WifiGuidePage> createState() => _WifiGuidePageState();
}

enum WifiStep {
  chooseNetwork,
  enterPassword,
  connecting,
  result,
}

class _WifiGuidePageState extends State<WifiGuidePage> {
  List<WifiNetwork> _wifiList = [];
  bool _isLoading = false;

  WifiStep _step = WifiStep.chooseNetwork;
  WifiNetwork? _selectedNetwork;
  bool _connectionSuccess = false;

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
        const SnackBar(
          content: Text('Location permission is required for Wi-Fi scanning'),
        ),
      );
    }
  }

  Future<void> _startScan() async {
    setState(() {
      _isLoading = true;
      _wifiList = [];
    });

    try {
      final results = await WiFiForIoTPlugin.loadWifiList();
      if (!mounted) return;

      setState(() {
        _wifiList = results
            .where((r) => r.ssid != null && r.ssid!.isNotEmpty)
            .toList();
        _wifiList.sort(
              (a, b) => (b.level ?? -100).compareTo(a.level ?? -100),
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _connectToWifi(WifiNetwork wifi, String password) async {
    setState(() {
      _step = WifiStep.connecting;
      _selectedNetwork = wifi;
    });

    try {
      final success = await WiFiForIoTPlugin.connect(
        wifi.ssid!,
        password: password,
        joinOnce: true,
      );

      if (!mounted) return;

      setState(() {
        _connectionSuccess = success;
        _step = WifiStep.result;
      });
    } catch (e) {
      setState(() {
        _connectionSuccess = false;
        _step = WifiStep.result;
      });
    }
  }

  Future<void> _askPassword(WifiNetwork wifi) async {
    final theme = Theme.of(context);
    final controller = TextEditingController();

    final password = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: theme.cardColor,
        title: Text(
          'Enter your home network password',
          style: theme.textTheme.titleMedium,
        ),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(hintText: 'Password'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(context, controller.text.trim()),
            child: const Text('Connect'),
          ),
        ],
      ),
    );

    if (password != null && password.isNotEmpty) {
      _connectToWifi(wifi, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            _buildHeader(theme),

            const SizedBox(height: 30),

            Expanded(child: _buildContent(theme)),

            SafeArea(
              minimum: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _step == WifiStep.result
                        ? () {
                      final user =
                          FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HomePage(user: user),
                          ),
                              (_) => false,
                        );
                      }
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    switch (_step) {
      case WifiStep.chooseNetwork:
        return Column(
          children: [
            Text(
              'Choose your home network',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Choose your home network from the list below',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        );

      case WifiStep.connecting:
        return Text(
          'Connecting Robot to your home network…',
          style: theme.textTheme.headlineSmall,
          textAlign: TextAlign.center,
        );

      case WifiStep.result:
        return Text(
          _connectionSuccess
              ? 'Robot connected to your home network'
              : 'Failed to connect to your home network',
          style: theme.textTheme.headlineSmall?.copyWith(
            color:
            _connectionSuccess ? AppColors.primary : Colors.redAccent,
          ),
          textAlign: TextAlign.center,
        );

      default:
        return const SizedBox();
    }
  }

  Widget _buildContent(ThemeData theme) {
    if (_step == WifiStep.chooseNetwork) {
      if (_isLoading) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      }

      return ListView.builder(
        itemCount: _wifiList.length,
        itemBuilder: (_, index) {
          final wifi = _wifiList[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => _askPassword(wifi),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Text(
                  wifi.ssid!,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),
          );
        },
      );
    }

    if (_step == WifiStep.connecting) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return const SizedBox();
  }
}
