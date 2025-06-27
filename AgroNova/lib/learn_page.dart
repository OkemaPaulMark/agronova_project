import 'package:flutter/material.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<_LearningData>> groupedItems = {
      'Seasonal Tips': [
        _LearningData(
          icon: Icons.local_florist,
          title: 'Best Crops for June',
          description: 'Guide on choosing the right crops this month.',
        ),
        _LearningData(
          icon: Icons.wb_sunny,
          title: 'Dry Season Tips',
          description: 'How to water your crops efficiently.',
        ),
      ],
      'Video Lessons': [
        _LearningData(
          icon: Icons.play_circle_fill,
          title: 'How to Spot Leaf Spot',
          description: 'Watch for visual signs and remedies.',
        ),
        _LearningData(
          icon: Icons.play_circle_fill,
          title: 'Using Fertilizers Properly',
          description: 'Best practices for fertilizer usage.',
        ),
      ],
      'Blog Articles': [
        _LearningData(
          icon: Icons.article,
          title: 'Benefits of Crop Rotation',
          description: 'Understand why rotation matters.',
        ),
        _LearningData(
          icon: Icons.article,
          title: 'Top 5 Farming Mistakes',
          description: 'Avoid common farming pitfalls.',
        ),
      ],
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Learn', style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: groupedItems.entries.expand<Widget>((entry) {
          final category = entry.key;
          final items = entry.value;

          return [
            // Simple category heading, aligned left
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
                textAlign: TextAlign.left,
              ),
            ),

            // The list of items for this category
            ...items.map((item) => LearningItem(
                  icon: item.icon,
                  title: item.title,
                  description: item.description,
                )),
          ];
        }).toList(),
      ),
    );
  }
}

class _LearningData {
  final IconData icon;
  final String title;
  final String description;

  _LearningData({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class LearningItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const LearningItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 40, color: Colors.green),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(description,
                    style: const TextStyle(fontSize: 15, color: Colors.black87)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
