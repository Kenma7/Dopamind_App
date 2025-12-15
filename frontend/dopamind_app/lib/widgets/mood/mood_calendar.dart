import 'package:flutter/material.dart';

class MoodCalendar extends StatefulWidget {
  final DateTime currentMonth;
  final Function(DateTime) onDateSelected;
  final Map<String, Map<String, dynamic>> moodData;

  const MoodCalendar({
    Key? key,
    required this.currentMonth,
    required this.onDateSelected,
    required this.moodData,
  }) : super(key: key);

  @override
  _MoodCalendarState createState() => _MoodCalendarState();
}

class _MoodCalendarState extends State<MoodCalendar> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.currentMonth;
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    ).day;
    final firstWeekday = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    ).weekday;
    final totalCells = firstWeekday - 1 + daysInMonth;
    final rows = (totalCells / 7).ceil();

    final List<String> dayLabels = ['M', 'S', 'S', 'R', 'K', 'J', 'S'];

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, size: 18),
                  onPressed: () => setState(
                    () => _currentMonth = DateTime(
                      _currentMonth.year,
                      _currentMonth.month - 1,
                      1,
                    ),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
                Text(
                  '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right, size: 18),
                  onPressed: () => setState(
                    () => _currentMonth = DateTime(
                      _currentMonth.year,
                      _currentMonth.month + 1,
                      1,
                    ),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),

            SizedBox(height: 8),

            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: 7,
              itemBuilder: (context, index) => Center(
                child: Text(
                  dayLabels[index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    fontSize: 10,
                  ),
                ),
              ),
            ),

            SizedBox(height: 2),

            Container(
              height: rows * 32.0,
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  childAspectRatio: 1,
                ),
                itemCount: firstWeekday - 1 + daysInMonth,
                itemBuilder: (context, index) {
                  if (index < firstWeekday - 1) return SizedBox();

                  final day = index - (firstWeekday - 1) + 1;
                  final date = DateTime(
                    _currentMonth.year,
                    _currentMonth.month,
                    day,
                  );
                  final dateKey =
                      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

                  final moodForDay = widget.moodData[dateKey];
                  final isToday = _isToday(date);

                  return GestureDetector(
                    onTap: () => widget.onDateSelected(date),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _getDayColor(moodForDay, isToday),
                        shape: BoxShape.circle,
                        border: isToday
                            ? Border.all(color: Colors.blue, width: 1.5)
                            : null,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              day.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: _getTextColor(moodForDay, isToday),
                                fontSize: 11,
                              ),
                            ),
                            if (moodForDay != null)
                              Padding(
                                padding: EdgeInsets.only(top: 1),
                                child: Text(
                                  _getMoodEmoji(
                                    moodForDay['mood']?.toString() ?? '',
                                  ),
                                  style: TextStyle(fontSize: 9),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 8),

            Wrap(
              spacing: 6,
              runSpacing: 2,
              alignment: WrapAlignment.center,
              children: [
                _buildLegendItem('😄', 'Sangat Baik', Colors.green[100]!),
                _buildLegendItem('🙂', 'Baik', Colors.lightGreen[100]!),
                _buildLegendItem('😐', 'Biasa', Colors.yellow[100]!),
                _buildLegendItem('😔', 'Buruk', Colors.red[100]!),
                _buildLegendItem('📅', 'Hari Ini', Colors.blue[100]!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getDayColor(Map<String, dynamic>? moodData, bool isToday) {
    if (moodData == null) return isToday ? Colors.blue[50]! : Colors.grey[100]!;
    final mood = moodData['mood']?.toString() ?? 'Biasa';
    switch (mood.toLowerCase()) {
      case 'sangat baik':
        return Colors.green[100]!;
      case 'baik':
        return Colors.lightGreen[100]!;
      case 'biasa':
        return Colors.yellow[100]!;
      case 'buruk':
        return Colors.red[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  Color _getTextColor(Map<String, dynamic>? moodData, bool isToday) {
    if (moodData == null)
      return isToday ? Colors.blue[800]! : Colors.grey[600]!;
    final mood = moodData['mood']?.toString() ?? 'Biasa';
    switch (mood.toLowerCase()) {
      case 'sangat baik':
        return Colors.green[800]!;
      case 'baik':
        return Colors.lightGreen[800]!;
      case 'biasa':
        return Colors.yellow[800]!;
      case 'buruk':
        return Colors.red[800]!;
      default:
        return Colors.grey[800]!;
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
        return '';
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month - 1];
  }

  Widget _buildLegendItem(String emoji, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          margin: EdgeInsets.only(right: 2),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Text(emoji, style: TextStyle(fontSize: 10)),
        SizedBox(width: 2),
        Text(label, style: TextStyle(fontSize: 9, color: Colors.grey[700])),
      ],
    );
  }
}
