// lib/widgets/mood/mood_grid.dart
import 'package:flutter/material.dart';
import 'mood_button.dart';

class MoodGrid extends StatefulWidget {
  final Function(String) onMoodSelected;
  final String? selectedMood;

  const MoodGrid({Key? key, required this.onMoodSelected, this.selectedMood})
    : super(key: key);

  @override
  _MoodGridState createState() => _MoodGridState();
}

class _MoodGridState extends State<MoodGrid> {
  final List<Map<String, dynamic>> moodOptions = [
    {'mood': 'Buruk', 'emoji': '😔', 'color': Colors.red},
    {'mood': 'Biasa', 'emoji': '😐', 'color': Colors.yellow},
    {'mood': 'Baik', 'emoji': '🙂', 'color': Colors.lightGreen},
    {'mood': 'Sangat Baik', 'emoji': '😄', 'color': Colors.green},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.9,
          ),
          itemCount: moodOptions.length,
          itemBuilder: (context, index) {
            final mood = moodOptions[index]['mood']! as String;
            final emoji = moodOptions[index]['emoji']! as String;
            final color = moodOptions[index]['color']! as Color;

            return MoodButton(
              mood: mood,
              emoji: emoji,
              color: color,
              isSelected: widget.selectedMood == mood,
              onTap: () => widget.onMoodSelected(mood),
            );
          },
        ),

        if (widget.selectedMood != null) ...[
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Mood hari ini: ${widget.selectedMood}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
