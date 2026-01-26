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
    final bottomInset = MediaQuery.of(context).padding.bottom;
    const barHeight = 64.0;
    const fabSize = 72.0;
    const barBottomPadding = 16.0;
    
    return Scaffold(
      body: Stack(
        children: [
          _pages[_currentIndex],
          
          // Floating Navigation Bar
          Positioned(
            left: 20,
            right: 20,
            bottom: barBottomPadding + bottomInset,
            child: Container(
              height: barHeight,
              decoration: BoxDecoration(
                color: isDark ? theme.cardColor : Colors.white,
                borderRadius: BorderRadius.circular(barHeight / 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.18),
                    blurRadius: 28,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(child: _buildNavItem(0, Icons.view_stream_outlined, 'Feed')),
                  Expanded(child: _buildNavItem(1, Icons.gamepad_outlined, 'Remote')),
                  const SizedBox(width: fabSize),
                  Expanded(child: _buildNavItem(3, Icons.video_library_outlined, 'Reels')),
                  Expanded(child: _buildNavItem(4, Icons.settings_outlined, 'Settings')),
                ],
              ),
            ),
          ),

          // Floating center Health button (separate from the toolbar)
          Positioned(
            left: 0,
            right: 0,
            bottom: barBottomPadding +
                bottomInset +
                ((barHeight - fabSize) / 2),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  setState(() => _currentIndex = 2);
                },
                child: Container(
                  width: fabSize,
                  height: fabSize,
                  decoration: BoxDecoration(
                    color: _currentIndex == 2 ? Colors.black : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.22),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.favorite,
                    size: 32,
                    color: _currentIndex == 2 ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() => _currentIndex = index);
      },
      child: Center(
        child: SizedBox(
          height: 42,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isSelected ? AppColors.primary : Colors.grey,
                  size: 20,
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9,
                      height: 1.0,
                      color: isSelected ? AppColors.primary : Colors.grey,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
