// lib/services/mood_service.dart - FULL VERSION FIXED
import 'dart:convert';
import 'package:http/http.dart' as http;

class MoodService {
  static const String baseUrl = 'http://localhost:8080/dopamind/api/mood/';

  /// 1. Save today's mood
  static Future<Map<String, dynamic>> saveDailyMood({
    required String mood,
    String note = '',
    String? date, // YYYY-MM-DD format
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}create.php'),
        body: {'mood': mood, 'note': note, 'date': date ?? _getTodayDate()},
      );

      print('✅ Save Mood Response: ${response.statusCode} - ${response.body}');

      final jsonData = json.decode(response.body);

      if (response.statusCode == 200 && jsonData['status'] == 'success') {
        return {
          'success': true,
          'message': jsonData['message'],
          'date': jsonData['date'],
        };
      } else {
        throw Exception(jsonData['message'] ?? 'Gagal menyimpan mood');
      }
    } catch (e) {
      print('❌ Error saveDailyMood: $e');
      rethrow;
    }
  }

  /// 2. Get moods for a specific month
  static Future<List<Map<String, dynamic>>> getMoodsForMonth({
    int? year,
    int? month,
  }) async {
    try {
      final now = DateTime.now();
      final targetYear = year ?? now.year;
      final targetMonth = month ?? now.month;
      final monthStr = '$targetYear-${targetMonth.toString().padLeft(2, '0')}';

      final response = await http.get(
        Uri.parse('${baseUrl}list.php?month=$monthStr'),
      );

      print('✅ Get Moods Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          final List list = jsonData['data'] ?? [];

          return list.map<Map<String, dynamic>>((e) {
            return {
              'id': e['id']?.toString() ?? '',
              'mood': e['mood']?.toString() ?? '',
              'note': e['note']?.toString() ?? '',
              'date': e['date']?.toString() ?? '',
              'created_at': e['created_at']?.toString() ?? '',
            };
          }).toList();
        } else {
          throw Exception(jsonData['message'] ?? 'Gagal mengambil data mood');
        }
      } else {
        throw Exception('HTTP Error ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error getMoodsForMonth: $e');
      return [];
    }
  }

  /// 3. Get monthly statistics
  static Future<Map<String, dynamic>> getMonthlyStats({
    int? year,
    int? month,
  }) async {
    try {
      final now = DateTime.now();
      final targetYear = year ?? now.year;
      final targetMonth = month ?? now.month;
      final monthStr = '$targetYear-${targetMonth.toString().padLeft(2, '0')}';

      final response = await http.get(
        Uri.parse('${baseUrl}stats.php?month=$monthStr'),
      );

      print('✅ Get Stats Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          final stats = jsonData['stats'] ?? {};

          // Ensure all values are properly typed
          return {
            'total_entries': _parseInt(stats['total_entries']),
            'average_mood': stats['average_mood']?.toString() ?? 'Biasa',
            'average_score': _parseDouble(stats['average_score']),
            'most_common_mood':
                stats['most_common_mood']?.toString() ?? 'Biasa',
            'most_common_count': _parseInt(stats['most_common_count']),
            'distribution': {
              'sangat_baik': _parseInt(stats['distribution']?['sangat_baik']),
              'baik': _parseInt(stats['distribution']?['baik']),
              'biasa': _parseInt(stats['distribution']?['biasa']),
              'buruk': _parseInt(stats['distribution']?['buruk']),
            },
          };
        } else {
          throw Exception(jsonData['message'] ?? 'Gagal mengambil statistik');
        }
      } else if (response.statusCode == 404) {
        print('⚠️ stats.php not found, returning empty stats');
        return _getEmptyStats();
      } else {
        throw Exception('HTTP Error ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error getMonthlyStats: $e');
      return _getEmptyStats();
    }
  }

  /// 4. Get today's mood (if exists)
  static Future<Map<String, dynamic>?> getTodayMood() async {
    try {
      final allMoods = await getMoodsForMonth();
      final today = _getTodayDate();

      for (var mood in allMoods) {
        if (mood['date'] == today) {
          return mood;
        }
      }
      return null;
    } catch (e) {
      print('❌ Error getTodayMood: $e');
      return null;
    }
  }

  /// 5. Get weekly data for chart
  static Future<List<Map<String, dynamic>>> getWeeklyMoods() async {
    try {
      final allMoods = await getMoodsForMonth();

      if (allMoods.isEmpty) {
        return _generateEmptyWeeklyData();
      }

      // Group by date
      final Map<String, List<Map<String, dynamic>>> groupedByDate = {};

      for (var mood in allMoods) {
        final dateStr = mood['date']?.toString() ?? '';
        if (dateStr.isNotEmpty) {
          if (!groupedByDate.containsKey(dateStr)) {
            groupedByDate[dateStr] = [];
          }
          groupedByDate[dateStr]!.add(mood);
        }
      }

      // Generate last 7 days
      return _generateWeeklyDataFromGroups(groupedByDate);
    } catch (e) {
      print('❌ Error getWeeklyMoods: $e');
      return _generateEmptyWeeklyData();
    }
  }

  // ========== HELPER METHODS ==========

  static String _getTodayDate() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  static List<Map<String, dynamic>> _generateEmptyWeeklyData() {
    final List<Map<String, dynamic>> weeklyData = [];
    final now = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day - i);
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      weeklyData.add({
        'date': dateStr,
        'mood': 'Biasa',
        'count': 0,
        'average_score': 2.0,
      });
    }

    return weeklyData;
  }

  static List<Map<String, dynamic>> _generateWeeklyDataFromGroups(
    Map<String, List<Map<String, dynamic>>> groupedByDate,
  ) {
    final List<Map<String, dynamic>> weeklyData = [];
    final now = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day - i);
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      final moodsForDay = groupedByDate[dateStr] ?? [];

      if (moodsForDay.isNotEmpty) {
        // Calculate stats for this day
        final stats = _calculateDailyStats(moodsForDay);
        weeklyData.add({
          'date': dateStr,
          'mood': stats['most_common_mood'],
          'count': moodsForDay.length,
          'average_score': stats['average_score'],
        });
      } else {
        // No data for this day
        weeklyData.add({
          'date': dateStr,
          'mood': 'Biasa',
          'count': 0,
          'average_score': 2.0,
        });
      }
    }

    return weeklyData;
  }

  static Map<String, dynamic> _calculateDailyStats(
    List<Map<String, dynamic>> moods,
  ) {
    double totalScore = 0;
    final Map<String, int> moodCounts = {
      'Sangat Baik': 0,
      'Baik': 0,
      'Biasa': 0,
      'Buruk': 0,
    };

    for (var mood in moods) {
      final moodStr = mood['mood']?.toString() ?? 'Biasa';
      totalScore += _moodToScore(moodStr);
      moodCounts[moodStr] = (moodCounts[moodStr] ?? 0) + 1;
    }

    // Find most common mood
    String mostCommonMood = 'Biasa';
    int highestCount = 0;
    moodCounts.forEach((mood, count) {
      if (count > highestCount) {
        highestCount = count;
        mostCommonMood = mood;
      }
    });

    return {
      'most_common_mood': mostCommonMood,
      'average_score': moods.isNotEmpty ? totalScore / moods.length : 2.0,
    };
  }

  static Map<String, dynamic> _getEmptyStats() {
    return {
      'total_entries': 0,
      'average_mood': 'Biasa',
      'average_score': 2.0,
      'most_common_mood': 'Biasa',
      'most_common_count': 0,
      'distribution': {'sangat_baik': 0, 'baik': 0, 'biasa': 0, 'buruk': 0},
    };
  }

  // Helper methods for type conversion
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      try {
        return int.tryParse(value) ?? 0;
      } catch (e) {
        return 0;
      }
    }
    if (value is double) return value.toInt();
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.tryParse(value) ?? 0.0;
      } catch (e) {
        return 0.0;
      }
    }
    return 0.0;
  }

  static double _moodToScore(String mood) {
    switch (mood.toLowerCase()) {
      case 'sangat baik':
        return 4.0;
      case 'baik':
        return 3.0;
      case 'biasa':
        return 2.0;
      case 'buruk':
        return 1.0;
      default:
        return 2.0;
    }
  }

  static String _scoreToMood(double score) {
    if (score >= 3.5) return 'Sangat Baik';
    if (score >= 2.5) return 'Baik';
    if (score >= 1.5) return 'Biasa';
    return 'Buruk';
  }
}
