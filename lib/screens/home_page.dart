import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_colors.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Health Monitor',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // ================= HEADER =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(32),
              ),
            ),
            child: Column(
              children: const [
                Icon(Icons.favorite_border, color: Colors.white, size: 48),
                SizedBox(height: 12),
                Text(
                  'Possible Health Issues',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'AI-powered health monitoring',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ================= SPLIT VIEW =================
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // Top Part - Neck Issue
                _buildHealthIssueCard(
                  theme: theme,
                  title: 'Neck Area - Skin Irritation',
                  severity: 'Medium',
                  severityColor: Colors.orange,
                  detectedTime: '2 hours ago',
                  description: 'Redness and scratching detected in neck area',
                  spotPosition: const Offset(0.35, 0.15), // neck position
                ),

                const SizedBox(height: 16),

                // Bottom Part - Thigh Issue
                _buildHealthIssueCard(
                  theme: theme,
                  title: 'Rear Thigh - Possible Injury',
                  severity: 'High',
                  severityColor: Colors.red,
                  detectedTime: '30 minutes ago',
                  description: 'Limping and sensitivity detected in rear thigh',
                  spotPosition: const Offset(0.65, 0.65), // thigh position
                ),

                const SizedBox(height: 100), // Space for floating nav bar
              ],
            ),
          ),
        ],
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
                    left: spotPosition.dx * MediaQuery.of(context).size.width * 0.8,
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
