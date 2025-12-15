// lib/services/journal_service.dart - EXTENDED VERSION
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class JournalService {
  static const String baseUrl = 'http://localhost:8080/dopamind/api/myjournal';

  // === JOURNAL PROMPTS DATABASE ===
  static final Map<String, List<String>> journalPrompts = {
    'gratitude': [
      'Apa yang kamu syukuri hari ini?',
      'Siapa yang ingin kamu ucapkan terima kasih?',
      'Hal kecil apa yang membuatmu tersenyum hari ini?',
      'Pengalaman positif apa yang baru saja terjadi?',
    ],
    'reflection': [
      'Bagaimana perasaanmu hari ini?',
      'Apa pelajaran yang kamu dapat hari ini?',
      'Apa yang ingin kamu perbaiki besok?',
      'Pencapaian kecil apa yang kamu raih?',
    ],
    'goal': [
      'Apa tujuan besarmu saat ini?',
      'Langkah kecil apa yang bisa kamu ambil hari ini?',
      'Apa yang menghalangi kemajuanmu?',
      'Bagaimana kamu mengukur kesuksesan?',
    ],
    'emotional': [
      'Emosi apa yang paling kuat kamu rasakan?',
      'Apa pemicu emosi tersebut?',
      'Bagaimana cara sehat mengelola emosimu?',
      'Apa yang membuatmu merasa lebih baik?',
    ],
    'memory': [
      'Momen berharga apa yang terjadi minggu ini?',
      'Kenangan indah apa yang ingin kamu simpan?',
      'Apa yang membuatmu bangga pada dirimu?',
      'Kapan terakhir kali kamu merasa sangat hidup?',
    ],
  };

  // === MOOD OPTIONS ===
  static final List<Map<String, dynamic>> moodOptions = [
    {'value': 'happy', 'label': '😊 Senang', 'color': 'FFD700'},
    {'value': 'sad', 'label': '😢 Sedih', 'color': '3498DB'},
    {'value': 'anxious', 'label': '😰 Cemas', 'color': 'E67E22'},
    {'value': 'calm', 'label': '😌 Tenang', 'color': '2ECC71'},
    {'value': 'energetic', 'label': '💪 Bersemangat', 'color': 'E74C3C'},
    {'value': 'neutral', 'label': '😐 Netral', 'color': '95A5A6'},
  ];

  // === TYPE OPTIONS ===
  static final List<Map<String, dynamic>> typeOptions = [
    {
      'value': 'gratitude',
      'label': 'Syukur',
      'icon': 'favorite',
      'color': '2ECC71',
    },
    {
      'value': 'reflection',
      'label': 'Refleksi',
      'icon': 'psychology',
      'color': '3498DB',
    },
    {'value': 'goal', 'label': 'Tujuan', 'icon': 'flag', 'color': 'E67E22'},
    {
      'value': 'emotional',
      'label': 'Emosi',
      'icon': 'emoji_emotions',
      'color': '9B59B6',
    },
    {
      'value': 'memory',
      'label': 'Kenangan',
      'icon': 'memory',
      'color': 'E91E63',
    },
  ];

  /// === FETCH JOURNALS (ORIGINAL - KEEP THIS) ===
  static Future<List<Map<String, dynamic>>> fetchJournals() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/list.php'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          final List list = jsonData['data'] ?? [];

          return list.map<Map<String, dynamic>>((e) {
            return {
              'id': e['id']?.toString() ?? '',
              'content': e['content']?.toString() ?? '',
              'created_at': e['created_at']?.toString() ?? '',
              'type': e['type']?.toString() ?? 'reflection',
              'mood': e['mood']?.toString() ?? '',
            };
          }).toList();
        } else {
          throw Exception(jsonData['message'] ?? 'Gagal mengambil jurnal');
        }
      } else {
        throw Exception('HTTP Error ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchJournals: $e');
      rethrow;
    }
  }

  /// === CREATE JOURNAL (EXTENDED) ===
  static Future<Map<String, dynamic>> createJournal({
    required String content,
    String type = 'reflection',
    String mood = 'neutral',
    String? prompt,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create.php'),
        body: {
          'content': content,
          'type': type,
          'mood': mood,
          'prompt': prompt ?? '',
        },
      );

      final jsonData = json.decode(response.body);

      if (response.statusCode == 200 && jsonData['status'] == 'success') {
        return {
          'success': true,
          'id': jsonData['id']?.toString(),
          'message': jsonData['message'] ?? 'Journal created successfully',
        };
      } else {
        throw Exception(jsonData['message'] ?? 'Gagal menyimpan jurnal');
      }
    } catch (e) {
      print('Error in createJournal: $e');
      rethrow;
    }
  }

  /// === DELETE JOURNAL (KEEP ORIGINAL) ===
  static Future<void> deleteJournal(String id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete.php'),
        body: {'id': id},
      );

      final jsonData = json.decode(response.body);

      if (response.statusCode == 200 && jsonData['status'] == 'success') {
        return;
      } else {
        throw Exception(jsonData['message'] ?? 'Gagal menghapus jurnal');
      }
    } catch (e) {
      print('Error in deleteJournal: $e');
      rethrow;
    }
  }

  /// === UPDATE JOURNAL (EXTENDED) ===
  static Future<void> updateJournal({
    required String id,
    required String content,
    String type = 'reflection',
    String mood = '',
    String? prompt,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update.php'),
        body: {
          'id': id,
          'content': content,
          'type': type,
          'mood': mood,
          'prompt': prompt ?? '',
        },
      );

      final jsonData = json.decode(response.body);

      if (response.statusCode == 200 && jsonData['status'] == 'success') {
        return;
      } else {
        throw Exception(jsonData['message'] ?? 'Gagal mengupdate jurnal');
      }
    } catch (e) {
      print('Error in updateJournal: $e');
      rethrow;
    }
  }

  // === NEW FEATURE: GET RANDOM PROMPT ===
  static String getRandomPrompt(String type) {
    final prompts = journalPrompts[type] ?? [];
    if (prompts.isEmpty) return 'Tuliskan pemikiranmu...';
    final index = DateTime.now().millisecondsSinceEpoch % prompts.length;
    return prompts[index];
  }

  // === NEW FEATURE: GET JOURNAL STATISTICS ===
  static Map<String, dynamic> getJournalStats(
    List<Map<String, dynamic>> journals,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final todayJournals = journals.where((journal) {
      try {
        final createdAt = DateTime.parse(journal['created_at'] ?? '');
        return createdAt.isAfter(today);
      } catch (e) {
        return false;
      }
    }).length;

    final byType = <String, int>{};
    final byMood = <String, int>{};

    for (var journal in journals) {
      final type = journal['type'] ?? 'reflection';
      final mood = journal['mood'] ?? '';

      byType[type] = (byType[type] ?? 0) + 1;
      if (mood.isNotEmpty) {
        byMood[mood] = (byMood[mood] ?? 0) + 1;
      }
    }

    return {
      'total': journals.length,
      'today': todayJournals,
      'byType': byType,
      'byMood': byMood,
    };
  }

  // === NEW FEATURE: GET TYPE LABEL ===
  static String getTypeLabel(String type) {
    for (var option in typeOptions) {
      if (option['value'] == type) {
        return option['label'];
      }
    }
    return type;
  }

  // === NEW FEATURE: GET MOOD LABEL ===
  static String getMoodLabel(String mood) {
    for (var option in moodOptions) {
      if (option['value'] == mood) {
        return option['label'];
      }
    }
    return mood;
  }

  // === NEW FEATURE: GET TYPE COLOR ===
  static String getTypeColor(String type) {
    for (var option in typeOptions) {
      if (option['value'] == type) {
        return option['color'];
      }
    }
    return '95A5A6'; // Grey default
  }

  // === NEW FEATURE: GET MOOD COLOR ===
  static String getMoodColor(String mood) {
    for (var option in moodOptions) {
      if (option['value'] == mood) {
        return option['color'];
      }
    }
    return '95A5A6'; // Grey default
  }

  // === NEW FEATURE: GET TYPE ICON ===
  static String getTypeIcon(String type) {
    for (var option in typeOptions) {
      if (option['value'] == type) {
        return option['icon'];
      }
    }
    return 'book';
  }

  // === NEW FEATURE: GET ALL TYPE OPTIONS ===
  static List<Map<String, dynamic>> getTypeOptions() {
    return typeOptions;
  }

  // === NEW FEATURE: GET ALL MOOD OPTIONS ===
  static List<Map<String, dynamic>> getMoodOptions() {
    return moodOptions;
  }

  // === NEW FEATURE: FORMAT DATE ===
  static String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy, HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
