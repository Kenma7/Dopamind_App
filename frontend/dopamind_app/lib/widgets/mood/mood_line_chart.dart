import 'package:flutter/material.dart';

class MoodLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> weeklyData;

  const MoodLineChart({Key? key, required this.weeklyData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final validData = weeklyData
        .where((day) => (day['count'] ?? 0) > 0)
        .toList();

    if (validData.isEmpty) {
      return _buildEmptyChart();
    }

    return Container(
      height: 180, // LEBIH KECIL DARI SEBELUMNYA
      padding: EdgeInsets.all(12),
      child: _buildChartContent(validData),
    );
  }

  Widget _buildChartContent(List<Map<String, dynamic>> validData) {
    // SEDERHANAKAN CHART UNTUK HINDARI OVERFLOW
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // LEGEND SIMPLE
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem('😄', 'Sangat Baik', Colors.green),
            SizedBox(width: 8),
            _buildLegendItem('🙂', 'Baik', Colors.lightGreen),
            SizedBox(width: 8),
            _buildLegendItem('😐', 'Biasa', Colors.yellow),
            SizedBox(width: 8),
            _buildLegendItem('😔', 'Buruk', Colors.red),
          ],
        ),

        SizedBox(height: 10),

        // SIMPLE BAR CHART
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: validData.length,
            itemBuilder: (context, index) {
              final day = validData[index];
              final mood = day['mood']?.toString() ?? 'Biasa';
              final score = day['average_score'] ?? 2.0;

              return Container(
                width: 40,
                margin: EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // BAR
                    Container(
                      width: 20,
                      height: (score * 20).toDouble(),
                      decoration: BoxDecoration(
                        color: _getMoodColor(mood).withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(height: 4),
                    // EMOJI
                    Text(_getMoodEmoji(mood), style: TextStyle(fontSize: 12)),
                    SizedBox(height: 2),
                    // TANGGAL
                    Text(
                      _getShortDate(day['date']?.toString() ?? ''),
                      style: TextStyle(fontSize: 8, color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyChart() {
    return Container(
      height: 180,
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timeline, size: 40, color: Colors.grey[400]),
          SizedBox(height: 8),
          Text(
            'Mulai tracking mood!',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Simpan mood hari ini untuk melihat chart',
            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  String _getShortDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}';
    } catch (e) {
      return dateStr;
    }
  }

  Color _getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'sangat baik':
        return Colors.green;
      case 'baik':
        return Colors.lightGreen;
      case 'biasa':
        return Colors.yellow;
      case 'buruk':
        return Colors.red;
      default:
        return Colors.grey;
    }
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

  Widget _buildLegendItem(String emoji, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Center(child: Text(emoji, style: TextStyle(fontSize: 8))),
        ),
        SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 8, color: Colors.grey[700])),
      ],
    );
  }
}
