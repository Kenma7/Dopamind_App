// lib/models/journal.dart
class Journal {
  final String id;
  final String content;
  final String type; // 'gratitude', 'reflection', 'goal', 'memory', 'emotional'
  final String mood; // 'happy', 'sad', 'anxious', 'calm', 'energetic'
  final DateTime createdAt;
  final String? prompt; // Untuk journal dengan prompt

  Journal({
    required this.id,
    required this.content,
    required this.type,
    required this.mood,
    required this.createdAt,
    this.prompt,
  });

  factory Journal.fromJson(Map<String, dynamic> json) {
    return Journal(
      id: json['id'].toString(),
      content: json['content'] ?? '',
      type: json['type'] ?? 'reflection',
      mood: json['mood'] ?? '',
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toString(),
      ),
      prompt: json['prompt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type,
      'mood': mood,
      'created_at': createdAt.toIso8601String(),
      'prompt': prompt,
    };
  }
}
