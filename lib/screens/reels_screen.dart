import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ReelsScreen extends StatelessWidget {
  const ReelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text(
          'Reels',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined,
                color: Colors.white),
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
                Icon(Icons.movie_creation_outlined,
                    color: Colors.white, size: 48),
                SizedBox(height: 12),
                Text(
                  'Daily Moments',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Captured by your robot cameras',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ================= GRID =================
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7,
              children: const [
                _ReelCard(
                  robotName: 'Rex Unit 01',
                  time: 'Today · 14:30',
                  duration: '00:15',
                  imageUrl: 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=600&q=80',
                ),
                _ReelCard(
                  robotName: 'Rover Scout',
                  time: 'Yesterday · 09:15',
                  duration: '00:12',
                  imageUrl: 'https://images.unsplash.com/photo-1574158622682-e40e69881006?w=600&q=80',
                ),
                _ReelCard(
                  robotName: 'Rex Unit 01',
                  time: 'Today · 14:30',
                  duration: '00:15',
                  imageUrl: 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=600&q=80',
                ),
                _ReelCard(
                  robotName: 'Rover Scout',
                  time: 'Yesterday · 09:15',
                  duration: '00:12',
                  imageUrl: 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=600&q=80',
                ),
                _ReelCard(
                  robotName: 'Rex Unit 01',
                  time: '2 days ago · 16:45',
                  duration: '00:18',
                  imageUrl: 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=600&q=80',
                ),
                _ReelCard(
                  robotName: 'Rover Scout',
                  time: '3 days ago · 11:20',
                  duration: '00:22',
                  imageUrl: 'https://images.unsplash.com/photo-1548681528-6a5c45b66b42?w=600&q=80',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReelCard extends StatelessWidget {
  final String robotName;
  final String time;
  final String duration;
  final String? imageUrl;

  const _ReelCard({
    required this.robotName,
    required this.time,
    required this.duration,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),

        // ✅ visible in light mode
        border: theme.brightness == Brightness.light
            ? Border.all(
          color: AppColors.divider.withOpacity(0.6),
        )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= THUMBNAIL =================
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.light
                        ? Colors.grey.shade300
                        : theme.cardColor,
                  ),
                  child: imageUrl != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.play_circle_outline,
                                    size: 48,
                                    color: theme.brightness == Brightness.light
                                        ? Colors.white
                                        : theme.iconTheme.color,
                                  ),
                                );
                              },
                            ),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_circle_outline,
                                  size: 36,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Icon(
                            Icons.play_circle_outline,
                            size: 48,
                            color: theme.brightness == Brightness.light
                                ? Colors.white
                                : theme.iconTheme.color,
                          ),
                        ),
                ),
              ),

              Positioned(
                right: 8,
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    duration,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ================= INFO =================
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.smart_toy_outlined,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        robotName,
                        style: theme.textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        time,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
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
