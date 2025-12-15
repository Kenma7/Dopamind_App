// data/dummy_data.dart
import '../models/meditasi.dart';

class DummyData {
  // === ARTICLES ===
  static List<Map<String, dynamic>> articles = [
    {
      'id': 1,
      'title': 'Apa itu kesehatan mental? Gejala & penyebab',
      'category': 'Education',
      'readTime': '5 min read',
      'imageUrl': '🧠',
      'description':
          'Artikel lengkap tentang pengertian kesehatan mental, gejala, dan penyebabnya...',
    },
    {
      'id': 2,
      'title': 'Cara mengatasi stress sehari-hari',
      'category': 'Tips & Tricks',
      'readTime': '3 min read',
      'imageUrl': '🌿',
      'description':
          'Tips praktis mengelola stress dalam kehidupan sehari-hari...',
    },
    {
      'id': 3,
      'title': 'Meditasi untuk pemula',
      'category': 'Meditation',
      'readTime': '7 min read',
      'imageUrl': '🧘‍♀️',
      'description': 'Panduan lengkap memulai praktik meditasi untuk pemula...',
    },
    {
      'id': 4,
      'title': 'Pentingnya self-care dalam kehidupan',
      'category': 'Self Care',
      'readTime': '4 min read',
      'imageUrl': '💖',
      'description':
          'Mengapa merawat diri sendiri penting untuk kesehatan mental...',
    },
    {
      'id': 5,
      'title': 'Mengenal anxiety dan cara mengelolanya',
      'category': 'Mental Health',
      'readTime': '6 min read',
      'imageUrl': '😌',
      'description':
          'Memahami anxiety disorder dan strategi untuk mengelolanya...',
    },
  ];

  // === READABLE ARTICLES ===
  static List<Map<String, dynamic>> readableArticles = [
    {
      'id': 1,
      'title': 'Mindfulness dalam Kehidupan Sehari-hari',
      'description':
          'Praktik mindfulness sederhana yang bisa dilakukan kapan saja...',
      'readTime': '4 min read',
      'category': 'Mindfulness',
    },
    {
      'id': 2,
      'description':
          'Langkah-langkah praktis untuk menjaga kesehatan mental...',
      'title': 'Panduan Kesehatan Mental Dasar',
      'readTime': '5 min read',
      'category': 'Mental Health',
    },
    {
      'id': 3,
      'title': 'Games untuk Melatih Mindfulness',
      'description':
          'Rekomendasi permainan sederhana untuk meningkatkan mindfulness...',
      'readTime': '3 min read',
      'category': 'Games',
    },
  ];

  // === MEDITATIONS === (HAPUS DUPLICATE!)
  static List<Meditation> get meditations {
    return [
      Meditation(
        id: '1',
        title: 'Hujan yang Menenangkan',
        description: 'Barkan rintik hujan membawamu menuju ketenangan.',
        duration: '10:00',
        category: 'Nature',
        emoji: '🌧️',
        audioUrl:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      ),
      Meditation(
        id: '2',
        title: 'Suara Hutan',
        description:
            'Dengarkan suara alam yang dapat membawamu kedalam nuansa yang terang dan damai.',
        duration: '15:00',
        category: 'Nature',
        emoji: '🌳',
        audioUrl:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      ),
      Meditation(
        id: '3',
        title: 'Malam yang Damai',
        description:
            'Bawa dirimu pada sang malam. Barkan ia menuntunmu kepada rasa kenyamanan.',
        duration: '12:00',
        category: 'Relaxation',
        emoji: '🌙',
        audioUrl:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      ),
      Meditation(
        id: '4',
        title: 'Fajar Menyingsing',
        description: 'Menyambut pagi dengan kedamaian dan energi baru.',
        duration: '08:00',
        category: 'Morning',
        emoji: '🌄',
        audioUrl:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      ),
      Meditation(
        id: '5',
        title: 'Ombak Laut',
        description: 'Gelombang laut yang menenangkan pikiran.',
        duration: '20:00',
        category: 'Nature',
        emoji: '🌊',
        audioUrl:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
      ),
      Meditation(
        id: '6',
        title: 'Taman Zen',
        description: 'Meditasi dalam ketenangan taman zen.',
        duration: '15:00',
        category: 'Relaxation',
        emoji: '🎍',
        audioUrl:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
      ),
      Meditation(
        id: '7',
        title: 'Meditasi Pernapasan',
        description: 'Fokus pada pernapasan untuk menenangkan pikiran',
        duration: '10:00',
        category: 'Breathing',
        emoji: '🌬️',
        audioUrl:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
      ),
    ];
  }

  // === MEDITATION GENRES ===
  static List<String> genres = [
    "Nature Sounds",
    "Guided Meditation",
    "Breathing Exercises",
    "Sleep Music",
    "Lo-fi",
    "Ambient",
  ];

  // === BREATHING EXERCISES ===
  static List<Map<String, dynamic>> breathingExercises = [
    {
      'id': 1,
      'title': 'Pernapasan 4-7-8',
      'description':
          'Teknik pernapasan untuk mengurangi kecemasan dan membantu tidur',
      'duration': '5 menit',
      'instructions': [
        'Tarik napas melalui hidung selama 4 detik',
        'Tahan napas selama 7 detik',
        'Hembuskan napas melalui mulut selama 8 detik',
        'Ulangi 4 kali',
      ],
    },
    {
      'id': 2,
      'title': 'Box Breathing',
      'description':
          'Teknik pernapasan untuk meningkatkan fokus dan ketenangan',
      'duration': '4 menit',
      'instructions': [
        'Tarik napas selama 4 detik',
        'Tahan napas selama 4 detik',
        'Hembuskan napas selama 4 detik',
        'Tahan napas selama 4 detik',
        'Ulangi selama 4 menit',
      ],
    },
  ];

  // === MEDITATION MUSIC ===
  static List<Map<String, dynamic>> meditationMusic = [
    {
      'id': 1,
      'title': 'Binaural Beats - Alpha Waves',
      'artist': 'Meditation Music Co.',
      'duration': '30:00',
      'category': 'Brain Waves',
      'color': 'purple',
    },
    {
      'id': 2,
      'title': 'Singing Bowl Meditation',
      'artist': 'Zen Sounds',
      'duration': '25:00',
      'category': 'Traditional',
      'color': 'blue',
    },
    {
      'id': 3,
      'title': 'Forest Ambience',
      'artist': 'Nature Sounds',
      'duration': '45:00',
      'category': 'Nature',
      'color': 'green',
    },
  ];
}
