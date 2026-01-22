import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

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
          'Video Feed',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          FeedVideoCard(
            robotName: 'Rex Unit 01',
            subtitle: '2 hours ago',
            duration: '00:45',
            isLive: false,
            imageUrl: 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=800&q=80',
          ),
          SizedBox(height: 16),
          FeedVideoCard(
            robotName: 'Rover Scout',
            subtitle: 'Live',
            duration: 'LIVE',
            isLive: true,
            imageUrl: 'https://images.unsplash.com/photo-1574158622682-e40e69881006?w=800&q=80',
          ),
          SizedBox(height: 16),
          FeedVideoCard(
            robotName: 'Rex Unit 01',
            subtitle: '5 hours ago',
            duration: '01:23',
            isLive: false,
            imageUrl: 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=800&q=80',
          ),
          SizedBox(height: 16),
          FeedVideoCard(
            robotName: 'Rover Scout',
            subtitle: 'Yesterday',
            duration: '02:15',
            isLive: false,
            imageUrl: 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=800&q=80',
          ),
        ],
      ),
    );
  }
}

class FeedVideoCard extends StatelessWidget {
  final String robotName;
  final String subtitle;
  final String duration;
  final bool isLive;
  final String? imageUrl;

  const FeedVideoCard({
    super.key,
    required this.robotName,
    required this.subtitle,
    required this.duration,
    required this.isLive,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // ================= VIDEO PREVIEW =================
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.light
                      ? Colors.grey.shade300
                      : theme.cardColor,
                  border: theme.brightness == Brightness.light
                      ? Border.all(
                          color: AppColors.divider.withOpacity(0.6),
                        )
                      : null,
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
                                  size: 64,
                                  color: theme.brightness == Brightness.light
                                      ? Colors.white
                                      : theme.iconTheme.color,
                                ),
                              );
                            },
                          ),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.play_circle_outline,
                                size: 48,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Icon(
                          Icons.play_circle_outline,
                          size: 64,
                          color: theme.brightness == Brightness.light
                              ? Colors.white
                              : theme.iconTheme.color,
                        ),
                      ),
              ),
            ),

            // Duration / LIVE badge
            Positioned(
              right: 12,
              bottom: 12,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isLive ? Colors.red : Colors.black87,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  duration,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),

            // LIVE chip
            if (isLive)
              Positioned(
                left: 12,
                top: 12,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 8),

        // ================= INFO ROW =================
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.smart_toy_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      robotName,
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.more_vert,
                    color: theme.iconTheme.color),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
