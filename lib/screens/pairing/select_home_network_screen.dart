import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'enter_network_password_screen.dart';

class SelectHomeNetworkScreen extends StatefulWidget {
  final String robotSSID;

  const SelectHomeNetworkScreen({super.key, required this.robotSSID});

  @override
  State<SelectHomeNetworkScreen> createState() =>
      _SelectHomeNetworkScreenState();
}

class _SelectHomeNetworkScreenState extends State<SelectHomeNetworkScreen> {
  final List<Map<String, dynamic>> _homeNetworks = [
    {'ssid': 'Home Network', 'signal': 95, 'secured': true},
    {'ssid': 'Office WiFi', 'signal': 78, 'secured': true},
    {'ssid': 'Guest Network', 'signal': 62, 'secured': false},
    {'ssid': 'Neighbor WiFi', 'signal': 45, 'secured': true},
  ];

  String? _selectedNetwork;
  bool _isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Select Home Network'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.home,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Choose Your Home Network',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Connected to: ${widget.robotSSID}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Available Networks',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _isScanning ? null : _scanNetworks,
                    icon: _isScanning
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh),
                    label: Text(_isScanning ? 'Scanning...' : 'Scan'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _homeNetworks.length,
                itemBuilder: (context, index) {
                  final network = _homeNetworks[index];
                  final isSelected = _selectedNetwork == network['ssid'];
                  return _buildNetworkCard(network, isSelected);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedNetwork != null
                      ? () {
                          final selectedNetworkData = _homeNetworks.firstWhere(
                            (n) => n['ssid'] == _selectedNetwork,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EnterNetworkPasswordScreen(
                                networkSSID: _selectedNetwork!,
                                robotSSID: widget.robotSSID,
                                isSecured: selectedNetworkData['secured'],
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkCard(Map<String, dynamic> network, bool isSelected) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedNetwork = network['ssid'];
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  network['secured'] ? Icons.wifi_lock : Icons.wifi,
                  color: isSelected ? AppColors.primary : Colors.grey,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      network['ssid'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      network['secured'] ? 'Secured' : 'Open',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    _getSignalIcon(network['signal']),
                    color: _getSignalColor(network['signal']),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${network['signal']}%',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              if (isSelected) ...[
                const SizedBox(width: 12),
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getSignalIcon(int signal) {
    if (signal >= 80) return Icons.signal_wifi_4_bar;
    if (signal >= 60) return Icons.signal_wifi_4_bar;
    if (signal >= 40) return Icons.signal_wifi_4_bar;
    return Icons.signal_wifi_4_bar;
  }

  Color _getSignalColor(int signal) {
    if (signal >= 80) return Colors.green;
    if (signal >= 60) return Colors.orange;
    return Colors.red;
  }

  void _scanNetworks() {
    setState(() {
      _isScanning = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    });
  }
}
