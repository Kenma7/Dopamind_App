import 'package:flutter/material.dart';
import '../services/journal_service.dart';
import 'journaldetailpage.dart';
import 'journalpage.dart';

class PulihPage extends StatefulWidget {
  @override
  _PulihPageState createState() => _PulihPageState();
}

class _PulihPageState extends State<PulihPage> {
  int _breathingCounter = 0;
  bool _isBreathing = false;
  List<Map<String, dynamic>> _journalList = [];
  final TextEditingController _gratitudeController = TextEditingController();
  final TextEditingController _editController = TextEditingController();

  final List<String> _affirmations = [
    "Kamu kuat, pasti semua berlalu 💫",
    "Terima kasih sudah bertahan sejauh ini, aku bangga 🌟",
    "Setiap langkah kecilmu adalah pencapaian yang besar 🎯",
    "Kamu lebih kuat dari yang kamu kira 💪",
    "Hari ini adalah kesempatan baru untuk tumbuh 🌱",
    "Perasaanmu valid, dan ini akan berlalu 🌈",
    "Kamu layak dicintai dan bahagia ❤️",
    "Tidak apa-apa untuk tidak baik-baik saja, yang penting tetap berjuang 🌻",
    "Kamu sedang melakukan yang terbaik, dan itu cukup 🏆",
    "Setiap napas adalah awal yang baru 🌬️",
    "Kamu tidak sendirian dalam perjalanan ini 🤝",
    "Progress kecil tetap progress yang berharga 📈",
  ];

  @override
  void initState() {
    super.initState();
    _loadGratitude();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ruang Pulih'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!, Colors.lightGreen[50]!, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "Ruang untuk Memulihkan Pikiran",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Aktivitas sederhana untuk proses pemulihan mental",
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: 24),

              // Breathing Exercise
              _buildBreathingGame(),
              SizedBox(height: 24),

              // Jurnal Syukur
              _buildGratitudeGame(),
              SizedBox(height: 24),

              // Mindfulness Activities
              _buildMindfulnessActivities(),
              SizedBox(height: 24),

              // Affirmation Section
              _buildAffirmationSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreathingGame() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.air, color: Colors.green, size: 28),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pernapasan Pemulihan",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                      Text(
                        "Teknik relaksasi untuk ketenangan",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: _isBreathing ? Colors.green[100] : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isBreathing
                        ? "Tahan... 7 detik"
                        : "Tarik napas... 4 detik",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _isBreathing
                          ? Colors.green[800]
                          : Colors.blue[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _isBreathing
                        ? "Lalu keluarkan 8 detik"
                        : "Hitungan: $_breathingCounter",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _toggleBreathing,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isBreathing ? Colors.orange : Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _isBreathing ? "BERHENTI" : "MULAI PEMULIHAN",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGratitudeGame() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.favorite, color: Colors.orange, size: 28),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Jurnal Pemulihan",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                        ),
                      ),
                      Text(
                        "Catatan harian untuk refleksi diri",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.refresh, color: Colors.orange),
                  onPressed: _loadGratitude,
                  tooltip: "Refresh jurnal",
                ),
              ],
            ),
            SizedBox(height: 16),

            // Input Jurnal Baru
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _gratitudeController,
                    decoration: InputDecoration(
                      hintText: "Apa yang ingin kamu refleksikan hari ini?",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: 2,
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_gratitudeController.text.isNotEmpty) {
                        _addGratitude(_gratitudeController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    child: Icon(Icons.add, size: 24),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Daftar Jurnal
            if (_journalList.isNotEmpty) ...[
              Text(
                "Jurnal Terbaru",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.green[800],
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              ..._journalList
                  .take(3)
                  .map((journal) => _buildJournalItem(journal))
                  .toList(),

              // Tampilkan "Lihat Semua" jika lebih dari 3
              if (_journalList.length > 3)
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JournalPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Lihat semua jurnal (${_journalList.length})",
                        style: TextStyle(color: Colors.orange[600]),
                      ),
                    ),
                  ),
                ),
            ] else if (_journalList.isEmpty) ...[
              Center(
                child: Column(
                  children: [
                    Icon(Icons.note_add, size: 50, color: Colors.grey[300]),
                    SizedBox(height: 8),
                    Text(
                      "Belum ada jurnal",
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Mulai tulis refleksi harianmu di atas",
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildJournalItem(Map<String, dynamic> journal) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        // ========== PERBAIKAN DI SINI ==========
        onTap: () => _navigateToJournalDetail(journal),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Konten Jurnal
              Text(
                journal['content'] ?? '',
                style: TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),

              // Info Tanggal & Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tanggal
                  Text(
                    journal['created_at'] != null
                        ? _formatDate(journal['created_at'])
                        : 'Hari ini',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),

                  // Action Buttons - Tetap ada untuk quick actions
                  Row(
                    children: [
                      // Edit Button
                      IconButton(
                        icon: Icon(Icons.edit, size: 18),
                        color: Colors.blue,
                        onPressed: () => _navigateToJournalDetail(journal),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        tooltip: "Buka di editor",
                      ),

                      // Delete Button
                      IconButton(
                        icon: Icon(Icons.delete, size: 18),
                        color: Colors.red,
                        onPressed: () => _showDeleteDialog(journal),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        tooltip: "Hapus jurnal",
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMindfulnessActivities() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Aktivitas Pemulihan Pikiran",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Latihan untuk menenangkan dan memulihkan pikiran",
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildActivityCard(
                  "Pemulihan Indera 5-4-3-2-1",
                  "Sebutkan 5 hal yang dilihat, 4 disentuh, 3 didengar, 2 dicium, 1 dirasakan",
                  Icons.visibility,
                  Colors.purple,
                ),
                _buildActivityCard(
                  "Perburuan Suara Pemulihan",
                  "Tutup mata, identifikasi 5 suara berbeda di sekitarmu",
                  Icons.hearing,
                  Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(
    String title,
    String description,
    IconData icon,
    MaterialColor color,
  ) {
    return InkWell(
      onTap: () => _showActivityInstructions(title, description),
      child: Container(
        width: 160,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color[100]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color[800],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAffirmationSection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.pink[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.psychology_alt,
                    color: Colors.pink,
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Afirmasi Pemulihan",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink[800],
                        ),
                      ),
                      Text(
                        "Kata-kata penyemangat untuk proses pemulihan",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.pink[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.pink[100]!),
              ),
              child: Column(
                children: [
                  Icon(Icons.favorite, color: Colors.pink, size: 40),
                  SizedBox(height: 12),
                  Text(
                    "Untuk Pemulihanmu...",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.pink[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Setiap hari adalah kesempatan baru untuk pulih 🌱",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _showRandomAffirmation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[100],
                  foregroundColor: Colors.pink[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.emergency, size: 24),
                    SizedBox(width: 8),
                    Text(
                      "BUTUH SEMANGAT PULIH",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _showCalmingMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[100],
                  foregroundColor: Colors.blue[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.spa, size: 24),
                    SizedBox(width: 8),
                    Text(
                      "BUTUH KETENANGAN",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== METHODS ==========
  void _toggleBreathing() {
    setState(() {
      _isBreathing = !_isBreathing;
      if (_isBreathing) {
        _breathingCounter++;
      }
    });
  }

  Future<void> _loadGratitude() async {
    try {
      final data = await JournalService.fetchJournals();
      setState(() {
        _journalList = data;
      });
      print('✅ Loaded ${_journalList.length} journals');
    } catch (e) {
      print('❌ Error loading journals: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat jurnal: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _addGratitude(String text) async {
    if (text.isEmpty) return;

    try {
      await JournalService.createJournal(
        content: text,
        type: 'reflection',
        mood: '',
      );
      _gratitudeController.clear();
      _loadGratitude();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Jurnal berhasil disimpan! ✨'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('❌ Error adding journal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan jurnal: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _deleteJournal(String id) async {
    try {
      await JournalService.deleteJournal(id);
      _loadGratitude();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Jurnal berhasil dihapus'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('❌ Error deleting journal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus jurnal: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _updateJournal(String id, String newContent) async {
    try {
      await JournalService.updateJournal(
        id: id,
        content: newContent,
        type: 'reflection',
        mood: '',
      );
      _loadGratitude();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Jurnal berhasil diperbarui! ✏️'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('❌ Error updating journal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui jurnal: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // ========== NAVIGASI KE DETAIL ==========
  void _navigateToJournalDetail(Map<String, dynamic> journal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalDetailPage(
          journal: journal,
          onJournalUpdated: _loadGratitude,
          onJournalDeleted: _loadGratitude,
        ),
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> journal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Hapus Jurnal?"),
        content: Text("Apakah Anda yakin ingin menghapus jurnal ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (journal['id'] != null) {
                _deleteJournal(journal['id'].toString());
              }
            },
            child: Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> journal) {
    _editController.text = journal['content'] ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Jurnal"),
        content: TextField(
          controller: _editController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: "Edit konten jurnal...",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              if (_editController.text.isNotEmpty && journal['id'] != null) {
                _updateJournal(journal['id'].toString(), _editController.text);
              }
              Navigator.pop(context);
            },
            child: Text("Simpan", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  void _showActivityInstructions(String title, String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Tutup"),
          ),
        ],
      ),
    );
  }

  void _showRandomAffirmation() {
    final randomAffirmation =
        _affirmations[_breathingCounter % _affirmations.length];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("💝 Untuk Proses Pemulihanmu"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.psychology_alt, color: Colors.pink, size: 40),
            SizedBox(height: 16),
            Text(
              randomAffirmation,
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              "Terus lanjutkan proses pemulihanmu!",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Terima Kasih 💖"),
          ),
        ],
      ),
    );
  }

  void _showCalmingMessage() {
    final calmingMessages = [
      "Kamu aman. Kamu terkendali. Ambil waktu sejenak untuk bernapas 🌬️",
      "Tidak apa-apa merasa lelah. Istirahat adalah bagian dari pemulihan 🌿",
      "Perasaan ini akan berlalu, seperti badai yang pasti reda 🌈",
      "Kamu kuat melewati hari ini, sama seperti hari-hari sebelumnya 💫",
      "Tidak perlu terburu-buru. Proses pemulihan butuh waktu 🕰️",
    ];

    final randomMessage =
        calmingMessages[_breathingCounter % calmingMessages.length];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("🕊️ Ambil Napas Dalam..."),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.spa, color: Colors.blue, size: 40),
            SizedBox(height: 16),
            Text(
              randomMessage,
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              "💧 Proses pemulihan butuh waktu",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Aku Mengerti 🫂"),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final journalDate = DateTime(date.year, date.month, date.day);

      if (journalDate == today) {
        return 'Hari ini, ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      } else if (journalDate == today.subtract(Duration(days: 1))) {
        return 'Kemarin, ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }
}
