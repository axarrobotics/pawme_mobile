import 'package:flutter/material.dart';
import 'dart:async';
import '../../constants/app_colors.dart';
import 'connection_result_screen.dart';

class ConnectingRobotScreen extends StatefulWidget {
  final String networkSSID;
  final String robotSSID;
  final String password;

  const ConnectingRobotScreen({
    super.key,
    required this.networkSSID,
    required this.robotSSID,
    required this.password,
  });

  @override
  State<ConnectingRobotScreen> createState() => _ConnectingRobotScreenState();
}

class _ConnectingRobotScreenState extends State<ConnectingRobotScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentStep = 0;
  final List<String> _steps = [
    'Connecting to robot...',
    'Sending network credentials...',
    'Robot connecting to network...',
    'Verifying connection...',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _simulateConnection();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _simulateConnection() async {
    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() {
          _currentStep = i;
        });
      }
    }

    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      final success = true;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ConnectionResultScreen(
            success: success,
            networkSSID: widget.networkSSID,
            robotSSID: widget.robotSSID,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Connecting Robot'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(),
              RotationTransition(
                turns: _controller,
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.sync,
                    size: 80,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              const Text(
                'Connecting Your Robot',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Connecting to ${widget.networkSSID}',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: List.generate(_steps.length, (index) {
                    final isCompleted = index < _currentStep;
                    final isCurrent = index == _currentStep;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? Colors.green
                                  : isCurrent
                                      ? AppColors.primary
                                      : Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: isCompleted
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                : isCurrent
                                    ? const SizedBox(
                                        width: 12,
                                        height: 12,
                                        child: Padding(
                                          padding: EdgeInsets.all(4),
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        ),
                                      )
                                    : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              _steps[index],
                              style: TextStyle(
                                fontSize: 14,
                                color: isCompleted || isCurrent
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                                fontWeight: isCurrent
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.3),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'This may take up to a minute. Please don\'t close the app.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
