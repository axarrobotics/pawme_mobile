import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_colors.dart';
import 'feed_screen.dart';
import 'remote_screen.dart';
import 'health_screen.dart';
import 'reels_screen.dart';
import 'settings_screen.dart';




class MainScaffold extends StatefulWidget {
  final User user;
  const MainScaffold({super.key, required this.user});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 2; // Health is default (center)

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const FeedScreen(),
      const RemoteScreen(),
      const HealthScreen(),
      const ReelsScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      body: Stack(
        children: [
          _pages[_currentIndex],
          
          // Floating Navigation Bar
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: isDark ? theme.cardColor : Colors.white,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(0, Icons.view_stream_outlined, 'Feed'),
                  _buildNavItem(1, Icons.gamepad_outlined, 'Remote'),
                  _buildNavItem(2, Icons.favorite, 'Health', isCenter: true),
                  _buildNavItem(3, Icons.video_library_outlined, 'Reels'),
                  _buildNavItem(4, Icons.settings_outlined, 'Settings'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {bool isCenter = false}) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() => _currentIndex = index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isCenter && isSelected
              ? Colors.black
              : isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isCenter && isSelected
                  ? Colors.white
                  : isSelected
                      ? AppColors.primary
                      : Colors.grey,
              size: isCenter ? 28 : 24,
            ),
            if (!isCenter || isSelected)
              const SizedBox(height: 4),
            if (!isCenter || isSelected)
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isCenter && isSelected
                      ? Colors.white
                      : isSelected
                          ? AppColors.primary
                          : Colors.grey,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Temporary placeholder pages (we will replace later)
class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
