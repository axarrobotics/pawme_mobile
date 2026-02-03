import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:nsd/nsd.dart';
import '../constants/app_colors.dart';

class RobotControlPage extends StatefulWidget {
  const RobotControlPage({super.key});

  @override
  State<RobotControlPage> createState() => _RobotControlPageState();
}

class _RobotControlPageState extends State<RobotControlPage> {
  String? _robotIp;
  bool _isSearching = true;
  String _statusMessage = "Initializing search...";
  Discovery? _discovery;

  @override
  void initState() {
    super.initState();
    _startDiscovery();
  }

  Future<void> _startDiscovery() async {
    setState(() {
      _isSearching = true;
      _robotIp = null;
      _statusMessage = "Searching for Pawme on WiFi...";
    });

    debugPrint("--- MDNS DISCOVERY STARTED ---");

    try {
      // Searching for the service defined in your firmware
      // We use '_http._tcp' as a fallback if '_pawme-cam._tcp' isn't being picked up
      _discovery = await startDiscovery('_http._tcp');

      debugPrint("NSD: Discovery object created. Listening for responses...");

      _discovery!.addListener(() {
        final services = _discovery!.services;
        debugPrint("NSD: Found ${services.length} services on network.");

        for (var service in services) {
          debugPrint("NSD: Found Service -> Name: ${service.name}, IP: ${service.addresses?.first.address}, Port: ${service.port}");

          // Logic to identify your robot: check port 81 (camera) or the name "pawme"
          if (service.port == 81 || service.name?.toLowerCase().contains("pawme") == true) {
            debugPrint("NSD: MATCH FOUND! Connecting to ${service.addresses?.first.address}");

            if (mounted) {
              setState(() {
                _robotIp = service.addresses?.first.address;
                _isSearching = false;
              });
            }
            stopDiscovery(_discovery!);
            return;
          }
        }
      });

      // Timeout logic
      await Future.delayed(const Duration(seconds: 8));
      if (_isSearching && mounted) {
        debugPrint("NSD: Discovery timed out after 8 seconds.");
        setState(() {
          _isSearching = false;
          _statusMessage = "Robot not found. Is it on the same WiFi?";
        });
        if (_discovery != null) stopDiscovery(_discovery!);
      }

    } catch (e) {
      debugPrint("NSD ERROR: $e");
      setState(() {
        _isSearching = false;
        _statusMessage = "Discovery Error: $e";
      });
    }
  }

  @override
  void dispose() {
    if (_discovery != null) stopDiscovery(_discovery!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(_isSearching ? "Searching..." : "Pawme Control"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isSearching ? null : _startDiscovery,
          )
        ],
      ),
      body: _isSearching
          ? _buildLoadingState()
          : _robotIp == null
          ? _buildErrorState()
          : _buildControlUI(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 24),
          Text(_statusMessage, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 8),
          const Text("Check your terminal for debug logs", style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(_statusMessage, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _startDiscovery,
              child: const Text("Retry Discovery"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlUI() {
    final String streamUrl = "http://$_robotIp:81/stream";

    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              Center(
                child: Mjpeg(
                  isLive: true,
                  stream: streamUrl,
                  error: (context, error, stack) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.videocam_off, color: Colors.red),
                      Text("Stream Error: $error", style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: Colors.black54,
                  child: Text("IP: $_robotIp", style: const TextStyle(color: Colors.green, fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
        _buildJoystick(),
      ],
    );
  }

  Widget _buildJoystick() {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildControlBtn(Icons.arrow_upward, "forward"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildControlBtn(Icons.arrow_back, "left"),
                const SizedBox(width: 40),
                _buildControlBtn(Icons.arrow_forward, "right"),
              ],
            ),
            _buildControlBtn(Icons.arrow_downward, "backward"),
          ],
        ),
      ),
    );
  }

  Widget _buildControlBtn(IconData icon, String command) {
    return GestureDetector(
      onTapDown: (_) => debugPrint("COMMAND: $command to http://$_robotIp/control?move=$command"),
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }
}