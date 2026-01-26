import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_colors.dart';
import '../services/auth_service.dart';
import 'welcome_screen.dart';
import 'robot_detail_page.dart';
import 'add_robot_instruction_screen.dart';
import 'health_showcase_screen.dart'; // ✅ NEW IMPORT

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color get _accentBlue => AppColors.primary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ================= HEADER =================
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage:
                          NetworkImage(widget.user.photoURL ?? ''),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, ${widget.user.displayName?.split(" ").first ?? 'User'}!',
                              style: theme.textTheme.titleLarge,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Welcome back to PawMe',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 130,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.settings_outlined),
                          onPressed: () {},
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              await AuthService().signOut();
                              if (mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const WelcomeScreen(),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.cardColor,
                              foregroundColor:
                              theme.textTheme.bodyLarge?.color,
                              elevation: 0,
                              padding:
                              const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Logout'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ================= ROBOTS =================
              Text(
                'Your Robots',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.8,
                children: [
                  _buildRobotCard('Rex Unit 01', '85%', '92%', true),
                  _buildRobotCard(
                    'Rover Scout',
                    '15%',
                    '0%',
                    false,
                    status: 'CHARGING',
                  ),
                  _buildAddRobotCard(),
                  _buildHealthShowcaseCard(), // ✅ NEW CARD
                ],
              ),

              const SizedBox(height: 30),

              // ================= DAILY ROUTINES =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daily Routines',
                    style: theme.textTheme.headlineMedium,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Manage All',
                      style: TextStyle(color: _accentBlue),
                    ),
                  ),
                ],
              ),

              _buildRoutineItem(
                Icons.medication_outlined,
                Colors.redAccent,
                'Morning Medicine',
                '08:00 AM',
                true,
              ),
              _buildRoutineItem(
                Icons.restaurant_outlined,
                Colors.orangeAccent,
                'Breakfast Kibble',
                '08:30 AM',
                true,
              ),
              _buildRoutineItem(
                Icons.directions_walk_outlined,
                Colors.greenAccent,
                'Park Walk',
                '05:00 PM',
                false,
              ),

              const SizedBox(height: 30),

              // ================= HEALTH ISSUES =================
              Text(
                'Possible Health Issues',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),

              _buildHealthIssueCard(
                theme: theme,
                title: 'Neck Area - Skin Irritation',
                severity: 'Medium',
                severityColor: Colors.orange,
                detectedTime: '2 hours ago',
                description: 'Redness and scratching detected in neck area',
                spotPosition: const Offset(0.35, 0.15),
              ),

              const SizedBox(height: 16),

              _buildHealthIssueCard(
                theme: theme,
                title: 'Rear Thigh - Possible Injury',
                severity: 'High',
                severityColor: Colors.red,
                detectedTime: '30 minutes ago',
                description: 'Limping and sensitivity detected in rear thigh',
                spotPosition: const Offset(0.65, 0.65),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ================= ROBOT CARD =================
  Widget _buildRobotCard(
      String name,
      String battery,
      String signal,
      bool isOnline, {
        String status = 'ONLINE',
      }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: theme.brightness == Brightness.light
            ? Border.all(
          color: AppColors.divider.withOpacity(0.6),
          width: 1,
        )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: theme.textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.show_chart, color: _accentBlue),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.circle,
                size: 8,
                color: isOnline
                    ? Colors.greenAccent
                    : Colors.orangeAccent,
              ),
              const SizedBox(width: 6),
              Text(status, style: theme.textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric('Battery', battery, Icons.battery_charging_full),
              _buildMetric('Signal', signal, Icons.wifi),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RobotDetailPage(
                      name: name,
                      battery: battery,
                      signal: signal,
                      status: status,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isOnline ? _accentBlue : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Details'),
            ),
          ),
        ],
      ),
    );
  }

  // ================= HEALTH SHOWCASE CARD =================
  Widget _buildHealthShowcaseCard() {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const HealthShowcaseScreen(),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: theme.brightness == Brightness.light
              ? Border.all(
            color: AppColors.primary.withOpacity(0.4),
            width: 1.2,
          )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite,
                size: 36, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(
              'Health Showcase',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Why your dog’s health matters',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData icon) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: theme.iconTheme.color),
            const SizedBox(width: 4),
            Text(label, style: theme.textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.titleMedium),
      ],
    );
  }

  Widget _buildAddRobotCard() {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AddRobotInstructionScreen(),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.dividerColor),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 32),
            SizedBox(height: 8),
            Text('Connect New Robot'),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineItem(
      IconData icon,
      Color iconBg,
      String title,
      String time,
      bool isDone,
      ) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: theme.brightness == Brightness.light
            ? Border.all(
                color: AppColors.divider.withOpacity(0.6),
              )
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconBg, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(time, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            Icon(
              isDone ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isDone ? Colors.greenAccent : theme.iconTheme.color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthIssueCard({
    required ThemeData theme,
    required String title,
    required String severity,
    required Color severityColor,
    required String detectedTime,
    required String description,
    required Offset spotPosition,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: theme.brightness == Brightness.light
            ? Border.all(
                color: AppColors.divider.withOpacity(0.6),
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dog silhouette with gradient spot
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.light
                  ? Colors.grey.shade100
                  : Colors.grey.shade900,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Stack(
                children: [
                  // Dog line graphic - full width
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/dog-line-graphic.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print('ERROR loading dog-line-graphic.png: $error');
                        // Fallback to custom painted dog if image not found
                        return Center(
                          child: CustomPaint(
                            size: const Size(280, 200),
                            painter: DogOutlinePainter(
                              color: theme.brightness == Brightness.light
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Gradient spot overlay on top
                  Positioned(
                    left: spotPosition.dx *
                        MediaQuery.of(context).size.width *
                        0.8,
                    top: spotPosition.dy * 200,
                    child: Image.asset(
                      'assets/images/red-gradient.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        print('ERROR loading red-gradient.png: $error');
                        // Fallback to custom painted gradient if image not found
                        return Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                severityColor.withOpacity(0.8),
                                severityColor.withOpacity(0.4),
                                severityColor.withOpacity(0.1),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.4, 0.7, 1.0],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Issue details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: severityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            size: 16,
                            color: severityColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            severity,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: severityColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Detected $detectedTime',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.medical_services_outlined, size: 18),
                    label: const Text('View Details & Recommendations'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for dog outline (fallback)
class DogOutlinePainter extends CustomPainter {
  final Color color;

  DogOutlinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Simplified dog silhouette
    // Head
    path.addOval(Rect.fromCircle(
      center: Offset(centerX - 60, centerY - 30),
      radius: 22,
    ));

    // Ear
    path.moveTo(centerX - 70, centerY - 48);
    path.lineTo(centerX - 78, centerY - 60);
    path.lineTo(centerX - 65, centerY - 52);

    // Body
    path.addOval(Rect.fromCenter(
      center: Offset(centerX + 10, centerY - 5),
      width: 100,
      height: 55,
    ));

    // Front legs
    path.moveTo(centerX - 25, centerY + 18);
    path.lineTo(centerX - 25, centerY + 55);
    
    path.moveTo(centerX - 10, centerY + 18);
    path.lineTo(centerX - 10, centerY + 55);

    // Back legs
    path.moveTo(centerX + 40, centerY + 18);
    path.lineTo(centerX + 40, centerY + 55);
    
    path.moveTo(centerX + 52, centerY + 18);
    path.lineTo(centerX + 52, centerY + 55);

    // Tail
    path.moveTo(centerX + 60, centerY - 10);
    path.quadraticBezierTo(
      centerX + 75,
      centerY - 25,
      centerX + 72,
      centerY - 40,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
