// lib/pages/home.dart - FULL VERSION WITH ARTICLES - FIXED VERSION
import 'package:flutter/material.dart';
import '../data/dummy.dart';
import '../widgets/artikel.dart';
import '../widgets/bacaartikel.dart';
import '../services/mood_service.dart';
import '../widgets/mood/mood_grid.dart';
import '../widgets/mood/mood_calendar.dart';
import '../widgets/mood/mood_stats.dart';
import '../widgets/mood/mood_line_chart.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // MOOD TRACKER STATE
  DateTime _currentMonth = DateTime.now();
  Map<String, Map<String, dynamic>> _moodData = {};
  Map<String, dynamic> _stats = {};
  bool _isLoadingMood = true;
  Map<String, dynamic>? _todayMood;
  List<Map<String, dynamic>> _weeklyMoods = [];

  // ARTICLES STATE
  final List<Map<String, dynamic>> _articles = DummyData.articles;
  final List<Map<String, dynamic>> _readableArticles =
      DummyData.readableArticles;

  @override
  void initState() {
    super.initState();
    _loadMoodData().then((_) {
      _generateWeeklyData();
    });
  }

  Future<void> _loadMoodData() async {
    setState(() => _isLoadingMood = true);

    try {
      // 1. Load moods for current month
      final moods = await MoodService.getMoodsForMonth(
        year: _currentMonth.year,
        month: _currentMonth.month,
      );

      // 2. Convert to map for easy lookup
      final Map<String, Map<String, dynamic>> moodMap = {};
      for (var mood in moods) {
        moodMap[mood['date'] ?? ''] = mood;
      }

      // 3. Get today's mood
      final todayMood = await MoodService.getTodayMood();

      // 4. Get monthly stats
      final stats = await MoodService.getMonthlyStats(
        year: _currentMonth.year,
        month: _currentMonth.month,
      );

      setState(() {
        _moodData = moodMap;
        _todayMood = todayMood;
        _stats = stats;
        _isLoadingMood = false;
      });
    } catch (e) {
      print('❌ Error loading mood data: $e');
      setState(() => _isLoadingMood = false);
    }
  }

  void _generateWeeklyData() async {
    try {
      // Method 1: Dari MoodService
      final weeklyData = await MoodService.getWeeklyMoods();

      // Method 2: Generate dari data yang ada
      if (weeklyData.isEmpty || weeklyData.every((day) => day['count'] == 0)) {
        // Buat data dummy untuk demo
        final now = DateTime.now();
        final List<Map<String, dynamic>> dummyData = [];

        for (int i = 6; i >= 0; i--) {
          final date = DateTime(now.year, now.month, now.day - i);
          final dateStr =
              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

          // Cek apakah ada mood untuk tanggal ini
          final moodForDate = _moodData[dateStr];

          if (moodForDate != null) {
            dummyData.add({
              'date': dateStr,
              'mood': moodForDate['mood'] ?? 'Biasa',
              'count': 1,
              'average_score': _moodToScore(
                moodForDate['mood']?.toString() ?? 'Biasa',
              ),
            });
          } else {
            // Random mood untuk demo
            final moods = ['Buruk', 'Biasa', 'Baik', 'Sangat Baik'];
            final randomMood = moods[(i % 4)];
            dummyData.add({
              'date': dateStr,
              'mood': randomMood,
              'count': 0, // 0 berarti data dummy
              'average_score': _moodToScore(randomMood),
            });
          }
        }

        setState(() {
          _weeklyMoods = dummyData;
        });
      } else {
        setState(() {
          _weeklyMoods = weeklyData;
        });
      }
    } catch (e) {
      print('❌ Error generating weekly data: $e');
    }
  }

  Future<void> _saveMood(String mood, {String note = ''}) async {
    try {
      final result = await MoodService.saveDailyMood(mood: mood, note: note);

      // Refresh data
      await _loadMoodData();
      _generateWeeklyData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mood "$mood" berhasil disimpan! ✅'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('❌ Error saving mood: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan mood. Coba lagi.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _onDateSelected(DateTime date) {
    final dateKey =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final moodForDate = _moodData[dateKey];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Mood ${date.day}/${date.month}/${date.year}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: moodForDate == null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.emoji_emotions_outlined,
                    size: 40,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text('Belum ada data mood untuk tanggal ini.'),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _getMoodEmoji(moodForDate['mood']?.toString() ?? ''),
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${moodForDate['mood']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _getMoodColor(
                            moodForDate['mood']?.toString() ?? '',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  if (moodForDate['note']?.isNotEmpty == true)
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Catatan: ${moodForDate['note']}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                ],
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
          if (moodForDate != null)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Edit mood functionality
                _showEditMoodDialog(dateKey, moodForDate);
              },
              child: Text('Edit', style: TextStyle(color: Colors.blue)),
            ),
        ],
      ),
    );
  }

  void _showEditMoodDialog(String dateKey, Map<String, dynamic> mood) {
    // TODO: Implement edit mood dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit functionality coming soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showArticleDetail(Map<String, dynamic> article) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          article['title']?.toString() ?? 'Judul Artikel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                article['description']?.toString() ??
                    'Ini adalah detail artikel tentang kesehatan mental.',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
              SizedBox(height: 16),
              if (article['category'] != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    article['category']!.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup', style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to full article page
            },
            child: Text('Baca Lengkap', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  Widget _buildWhiteContainer({
    required String title,
    required Widget content,
    Color? backgroundColor,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          SizedBox(height: 16),
          content,
        ],
      ),
    );
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

  double _moodToScore(String mood) {
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
        return 2.0; // Default score for "Biasa"
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text(
          'Dopamind',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _loadMoodData();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Refreshing data...'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'Refresh data',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === HEADER GREETING ===
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.waving_hand,
                          color: Colors.blue,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hai, User! 👋",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              ),
                            ),
                            Text(
                              "Bagaimana perasaanmu hari ini?",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Mulai hari dengan mengecek mood dan baca artikel inspiratif untuk kesehatan mentalmu.",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // === MOOD TRACKER SECTION ===
            _buildWhiteContainer(
              backgroundColor: Colors.white,
              title: "💭 Track Mood Hari Ini",
              content: Column(
                children: [
                  if (_todayMood != null)
                    Container(
                      margin: EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Mood hari ini: ${_todayMood!['mood']}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.green[800],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                  MoodGrid(
                    onMoodSelected: _saveMood,
                    selectedMood: _todayMood?['mood']?.toString(),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Pilih mood yang sesuai dengan perasaanmu sekarang',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // === MOOD STATISTICS ===
            if (!_isLoadingMood && _stats.isNotEmpty)
              MoodStatsCard(stats: _stats),

            SizedBox(height: 20),

            // === MOOD CHART ===
            if (_weeklyMoods.isNotEmpty)
              _buildWhiteContainer(
                backgroundColor: Colors.white,
                title: "📈 Trend Mood 7 Hari",
                content: Column(
                  children: [
                    SizedBox(
                      height: 200, // TINGGI FIXED UNTUK CHART
                      child: MoodLineChart(weeklyData: _weeklyMoods),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Perkembangan moodmu selama seminggu terakhir',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 20),
            // === MOOD CALENDAR ===
            if (!_isLoadingMood)
              _buildWhiteContainer(
                backgroundColor: Colors.white,
                title: "📅 Kalender Mood",
                content: Column(
                  children: [
                    MoodCalendar(
                      currentMonth: _currentMonth,
                      onDateSelected: _onDateSelected,
                      moodData: _moodData,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Klik tanggal untuk melihat detail mood',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 24),

            // === REKOMENDASI ARTIKEL ===
            _buildWhiteContainer(
              backgroundColor: Colors.white,
              title: "📚 Artikel Rekomendasi",
              content: Column(
                children: [
                  ArticleCard(
                    title:
                        _articles[0]['title']?.toString() ??
                        'Tips Menjaga Kesehatan Mental',
                    category:
                        _articles[0]['category']?.toString() ??
                        'Kesehatan Mental',
                    readTime:
                        _articles[0]['readTime']?.toString() ?? '5 min read',
                    emoji: _articles[0]['imageUrl']?.toString() ?? '🧠',
                    onTap: () => _showArticleDetail(_articles[0]),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Artikel pilihan untuk memulai perjalanan kesehatan mentalmu',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // === ARTIKEL YANG DAPAT DIBACA ===
            _buildWhiteContainer(
              backgroundColor: Colors.white,
              title: "🔍 Artikel yang Dapat Dibaca",
              content: Column(
                children: _readableArticles.map((article) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: ReadableArticleCard(
                      title: article['title']?.toString() ?? 'Judul Artikel',
                      description:
                          article['description']?.toString() ??
                          'Deskripsi artikel tentang kesehatan mental.',
                      onTap: () => _showArticleDetail(article),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 20),

            // === ARTIKEL LAINNYA ===
            _buildWhiteContainer(
              backgroundColor: Colors.white,
              title: "📖 Artikel Lainnya",
              content: Column(
                children: _articles.skip(1).map((article) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: ArticleCard(
                      title: article['title']?.toString() ?? 'Judul Artikel',
                      category: article['category']?.toString() ?? 'Kategori',
                      readTime: article['readTime']?.toString() ?? '5 min read',
                      emoji: article['imageUrl']?.toString() ?? '📖',
                      onTap: () => _showArticleDetail(article),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 40),

            // === FOOTER ===
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Column(
                children: [
                  Text(
                    '💫 Dopamind - Teman Kesehatan Mentalmu',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Terus pantau mood dan jaga kesehatan mentalmu setiap hari.',
                    style: TextStyle(fontSize: 12, color: Colors.blue[600]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.psychology_alt, size: 14, color: Colors.blue),
                      SizedBox(width: 4),
                      Text(
                        'Mental Health Matters',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.blue[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
