// lib/widgets/mood/mood_history.dart
import 'package:flutter/material.dart';

class MoodHistory extends StatelessWidget {
  final List<Map<String, dynamic>> moods;
  final bool isLoading;
  final VoidCallback onRefresh;

  const MoodHistory({
    Key? key,
    required this.moods,
    required this.isLoading,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Riwayat Mood Terbaru',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            IconButton(
              icon: Icon(Icons.refresh, size: 20),
              onPressed: onRefresh,
              color: Colors.blue,
            ),
          ],
        ),
        SizedBox(height: 12),

        if (isLoading)
          Center(child: CircularProgressIndicator())
        else if (moods.isEmpty)
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                Icon(Icons.emoji_emotions, size: 40, color: Colors.grey[300]),
                SizedBox(height: 8),
                Text(
                  'Belum ada riwayat mood',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          )
        else
          ...moods.take(3).map((mood) => _buildMoodItem(mood)).toList(),
      ],
    );
  }

  Widget _buildMoodItem(Map<String, dynamic> mood) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(
                _getMoodEmoji(mood['mood']?.toString() ?? ''),
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mood['mood']?.toString() ?? '',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                SizedBox(height: 2),
                Text(
                  mood['note']?.toString() ?? 'Tanpa catatan',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMoodEmoji(String mood) {
    switch (mood.toLowerCase()) {
      case 'sangat baik':
        return '😄';
      case 'baik':
        return '🙂';
      case 'biasa':
        return '😐';
      case 'buruk':
        return '😔';
      default:
        return '😐';
    }
  }
}
