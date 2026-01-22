import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

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
                  'Health Analysis',
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
                  spotPosition: const Offset(0.5, 0.25), // neck position
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
                  spotPosition: const Offset(0.7, 0.7), // thigh position
                ),
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
          // Dog silhouette with red spot
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.light
                  ? Colors.grey.shade100
                  : Colors.grey.shade900,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Stack(
              children: [
                // Dog outline
                Center(
                  child: CustomPaint(
                    size: const Size(180, 180),
                    painter: DogOutlinePainter(
                      color: theme.brightness == Brightness.light
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
                // Red spot indicator
                Positioned(
                  left: spotPosition.dx * 180 + 90,
                  top: spotPosition.dy * 180 + 10,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: severityColor.withOpacity(0.3),
                      border: Border.all(
                        color: severityColor,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: severityColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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

// Custom painter for dog outline
class DogOutlinePainter extends CustomPainter {
  final Color color;

  DogOutlinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final path = Path();

    // Simple dog silhouette outline
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Head (circle)
    path.addOval(Rect.fromCircle(
      center: Offset(centerX - 30, centerY - 40),
      radius: 25,
    ));

    // Ear
    path.moveTo(centerX - 40, centerY - 60);
    path.lineTo(centerX - 50, centerY - 75);
    path.lineTo(centerX - 35, centerY - 65);

    // Body (ellipse)
    path.addOval(Rect.fromCenter(
      center: Offset(centerX + 10, centerY),
      width: 80,
      height: 50,
    ));

    // Front leg
    path.moveTo(centerX - 15, centerY + 20);
    path.lineTo(centerX - 15, centerY + 60);

    // Back leg
    path.moveTo(centerX + 30, centerY + 20);
    path.lineTo(centerX + 30, centerY + 60);

    // Tail
    path.moveTo(centerX + 50, centerY - 5);
    path.quadraticBezierTo(
      centerX + 65,
      centerY - 20,
      centerX + 60,
      centerY - 35,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
