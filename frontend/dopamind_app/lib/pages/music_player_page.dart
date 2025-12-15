import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/meditasi.dart';

class MusicPlayerPage extends StatefulWidget {
  final Meditation meditation;
  final List<Meditation> playlist;

  const MusicPlayerPage({
    Key? key,
    required this.meditation,
    this.playlist = const [],
  }) : super(key: key);

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupAudio();
    _setupListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _setupAudio() async {
    // NOTE: Untuk demo, kita pakai audio URL dummy
    // Di production, ganti dengan URL audio asli
    const audioUrl =
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

    try {
      await _audioPlayer.setSourceUrl(audioUrl);
      final duration = await _audioPlayer.getDuration();
      if (duration != null) {
        setState(() {
          _duration = duration;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading audio: $e');
      setState(() => _isLoading = false);
    }
  }

  void _setupListeners() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() => _position = position);
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() => _isPlaying = false);
      // Auto play next track jika ada
      _playNext();
    });
  }

  void _playPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  void _seekTo(double value) async {
    final position = Duration(seconds: value.toInt());
    await _audioPlayer.seek(position);
  }

  void _playNext() {
    // Logic untuk play next track dari playlist
    final currentIndex = widget.playlist.indexWhere(
      (m) => m.id == widget.meditation.id,
    );

    if (currentIndex != -1 && currentIndex + 1 < widget.playlist.length) {
      final nextMeditation = widget.playlist[currentIndex + 1];
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MusicPlayerPage(
            meditation: nextMeditation,
            playlist: widget.playlist,
          ),
        ),
      );
    }
  }

  void _playPrevious() {
    final currentIndex = widget.playlist.indexWhere(
      (m) => m.id == widget.meditation.id,
    );

    if (currentIndex > 0) {
      final prevMeditation = widget.playlist[currentIndex - 1];
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MusicPlayerPage(
            meditation: prevMeditation,
            playlist: widget.playlist,
          ),
        ),
      );
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[900],
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Sedang Diputar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.more_vert, color: Colors.white),
                  ),
                ],
              ),
            ),

            // ALBUM ART
            Expanded(
              child: Center(
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.purple[700]!, Colors.deepPurple[900]!],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      widget.meditation.emoji,
                      style: TextStyle(fontSize: 80),
                    ),
                  ),
                ),
              ),
            ),

            // SONG INFO
            Container(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                children: [
                  Text(
                    widget.meditation.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.meditation.category,
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 32),

                  // PROGRESS BAR
                  if (!_isLoading) ...[
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 4,
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 8,
                        ),
                        overlayShape: RoundSliderOverlayShape(
                          overlayRadius: 16,
                        ),
                        activeTrackColor: Colors.purple[300],
                        inactiveTrackColor: Colors.white24,
                        thumbColor: Colors.white,
                      ),
                      child: Slider(
                        min: 0,
                        max: _duration.inSeconds.toDouble(),
                        value: _position.inSeconds.toDouble(),
                        onChanged: _seekTo,
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_position),
                            style: TextStyle(color: Colors.white70),
                          ),
                          Text(
                            _formatDuration(_duration),
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32),

                    // PLAYER CONTROLS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Shuffle
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.shuffle,
                            color: Colors.white70,
                            size: 24,
                          ),
                        ),
                        Spacer(),

                        // Previous
                        IconButton(
                          onPressed: _playPrevious,
                          icon: Icon(
                            Icons.skip_previous_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        SizedBox(width: 24),

                        // Play/Pause
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.5),
                                blurRadius: 15,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: _playPause,
                            icon: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.purple[900],
                              size: 36,
                            ),
                            padding: EdgeInsets.all(20),
                          ),
                        ),
                        SizedBox(width: 24),

                        // Next
                        IconButton(
                          onPressed: _playNext,
                          icon: Icon(
                            Icons.skip_next_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        Spacer(),

                        // Repeat
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.repeat,
                            color: Colors.white70,
                            size: 24,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 32),

                    // ADDITIONAL CONTROLS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        SizedBox(width: 40),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.download_outlined,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        SizedBox(width: 40),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.playlist_add,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Memuat audio...',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
