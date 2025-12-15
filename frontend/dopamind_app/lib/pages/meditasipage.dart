import 'package:flutter/material.dart';
import '../data/dummy.dart';
import '../models/meditasi.dart';
import 'music_player_page.dart';

class MeditationPage extends StatefulWidget {
  @override
  _MeditationPageState createState() => _MeditationPageState();
}

class _MeditationPageState extends State<MeditationPage> {
  String? selectedGenre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ruang Meditasi'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple[100]!, Colors.blue[50]!, Colors.white],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Text(
                "Rekomendasi untukmu",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800],
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Temukan ketenangan dalam setiap sesi",
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: 24),

              // Meditation List
              Column(
                children: DummyData
                    .meditations // INI AKAN AMAN SEKARANG
                    .map((meditation) => _buildMeditationCard(meditation))
                    .toList(),
              ),

              SizedBox(height: 32),

              // Genre Section
              Text(
                "Genre",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800],
                ),
              ),
              SizedBox(height: 12),

              // Genre Chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: DummyData.genres
                    .map(
                      (genre) => FilterChip(
                        label: Text(genre),
                        selected: selectedGenre == genre,
                        onSelected: (selected) {
                          setState(() {
                            selectedGenre = selected ? genre : null;
                          });
                        },
                        selectedColor: Colors.purple[100],
                        checkmarkColor: Colors.purple,
                        labelStyle: TextStyle(
                          color: selectedGenre == genre
                              ? Colors.purple
                              : Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                    .toList(),
              ),

              SizedBox(height: 32),

              // Featured Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.purple[50]!, Colors.blue[50]!],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mulai Perjalanan Meditasimu",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Pilih sesi meditasi yang sesuai dengan kebutuhanmu hari ini",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          // Play random meditation
                          if (DummyData.meditations.isNotEmpty) {
                            _playMeditation(DummyData.meditations.first);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[600],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Mulai Meditasi",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeditationCard(Meditation meditation) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Emoji/Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(meditation.emoji, style: TextStyle(fontSize: 24)),
              ),
            ),
            SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meditation.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    meditation.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        meditation.duration,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      SizedBox(width: 16),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          meditation.category,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.purple[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Play Button
            IconButton(
              onPressed: () => _playMeditation(meditation),
              icon: Icon(Icons.play_arrow_rounded, color: Colors.purple),
              style: IconButton.styleFrom(
                backgroundColor: Colors.purple[50],
                padding: EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _playMeditation(Meditation meditation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MusicPlayerPage(
          meditation: meditation,
          playlist: DummyData.meditations,
        ),
      ),
    );
  }
}
