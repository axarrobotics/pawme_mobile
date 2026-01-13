import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_colors.dart';
import '../services/auth_service.dart';
import 'welcome_screen.dart';
import '../robot_control_page.dart';
import '../wifi_guide_page.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color _backgroundColor = Color(0xFFF5F5F5);
  static const Color _cardColor = Colors.white;
  static final Color _accentBlue = AppColors.primary;
  static final Color _textSecondary = AppColors.textSecondary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // 1. Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(widget.user.photoURL ?? ''),
                        backgroundColor: Colors.grey[800],
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${widget.user.displayName?.split(" ").first ?? 'User'}!',
                            style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text('Welcome back to PawMe', style: TextStyle(color: _textSecondary, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.settings_outlined, color: Colors.white70),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          await AuthService().signOut();
                          if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const WelcomeScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white10,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Logout'),
                      ),
                    ],
                  )
                ],
              ),

              const SizedBox(height: 30),
              Text('Your Robots', style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // 2. Grid (Contains the "Connect New Robot" card)
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.85,
                children: [
                  _buildRobotCard('Rex Unit 01', '85%', '92%', true),
                  _buildRobotCard('Rover Scout', '15%', '0%', false, status: 'CHARGING'),
                  _buildAddRobotCard(), // The trigger for WifiGuidePage
                ],
              ),

              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Daily Routines', style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
                  TextButton(onPressed: () {}, child: Text('Manage All', style: TextStyle(color: _accentBlue))),
                ],
              ),

              _buildRoutineItem(Icons.medication_outlined, Colors.redAccent, 'Morning Medicine', '08:00 AM', true),
              _buildRoutineItem(Icons.restaurant_outlined, Colors.orangeAccent, 'Breakfast Kibble', '08:30 AM', true),
              _buildRoutineItem(Icons.directions_walk_outlined, Colors.greenAccent, 'Park Walk', '05:00 PM', false),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRobotCard(String name, String battery, String signal, bool isOnline, {String status = 'ONLINE'}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(name, style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis)),
              Icon(Icons.show_chart, color: _accentBlue, size: 20),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.circle, color: isOnline ? Colors.greenAccent : Colors.orangeAccent, size: 8),
              const SizedBox(width: 6),
              Text(status, style: TextStyle(color: _textSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric('Battery', battery, Icons.battery_charging_full),
              _buildMetric('Signal', signal, Icons.wifi),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RobotControlPage(robotUrl: ''))),
              icon: const Icon(Icons.power_settings_new, size: 16),
              label: const Text('Control'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isOnline ? _accentBlue : Colors.white12,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Icon(icon, size: 12, color: _textSecondary), const SizedBox(width: 4), Text(label, style: TextStyle(color: _textSecondary, fontSize: 10))]),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // --- Fixed Add Robot Card with Navigation Logic ---
  Widget _buildAddRobotCard() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const WifiGuidePage(robotSSID: 'ROBOT_AP'),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10, style: BorderStyle.solid),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppColors.textSecondary, size: 32),
            SizedBox(height: 8),
            Text('Connect New Robot', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineItem(IconData icon, Color iconBg, String title, String time, bool isDone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconBg.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconBg),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                Text(time, style: TextStyle(color: _textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Icon(isDone ? Icons.check_circle : Icons.radio_button_unchecked, color: isDone ? _accentBlue : _textSecondary),
        ],
      ),
    );
  }
}
