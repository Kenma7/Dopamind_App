// lib/widgets/mood/mood_stats_card.dart - FIXED
import 'package:flutter/material.dart';

class MoodStatsCard extends StatelessWidget {
  final Map<String, dynamic> stats;

  const MoodStatsCard({Key? key, required this.stats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty) return SizedBox();

    // Parse distribution values dengan aman
    final distribution = stats['distribution'] ?? {};
    final sangatBaik = _parseInt(distribution['sangat_baik']);
    final baik = _parseInt(distribution['baik']);
    final biasa = _parseInt(distribution['biasa']);
    final buruk = _parseInt(distribution['buruk']);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.insights, color: Colors.purple, size: 20),
                SizedBox(width: 8),
                Text(
                  '📊 Statistik Mood Bulan Ini',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Stats Row
            Row(
              children: [
                _buildStatCard(
                  'Rata-rata',
                  stats['average_mood']?.toString() ?? '-',
                  Icons.trending_up,
                  Colors.blue,
                ),
                SizedBox(width: 12),
                _buildStatCard(
                  'Paling Sering',
                  stats['most_common_mood']?.toString() ?? '-',
                  Icons.emoji_emotions,
                  Colors.green,
                ),
                SizedBox(width: 12),
                _buildStatCard(
                  'Total',
                  stats['total_entries']?.toString() ?? '0',
                  Icons.history,
                  Colors.purple,
                ),
              ],
            ),

            SizedBox(height: 16),

            // Distribution
            Text(
              'Distribusi Mood:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDistributionItem(
                  '😄',
                  'Sangat Baik',
                  sangatBaik,
                  Colors.green,
                ),
                _buildDistributionItem('🙂', 'Baik', baik, Colors.lightGreen),
                _buildDistributionItem('😐', 'Biasa', biasa, Colors.yellow),
                _buildDistributionItem('😔', 'Buruk', buruk, Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper untuk parse int dengan aman
  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      try {
        return int.tryParse(value) ?? 0;
      } catch (e) {
        return 0;
      }
    }
    return 0;
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionItem(
    String emoji,
    String label,
    int count,
    Color color,
  ) {
    return Column(
      children: [
        Text(emoji, style: TextStyle(fontSize: 20)),
        SizedBox(height: 4),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      ],
    );
  }
}
