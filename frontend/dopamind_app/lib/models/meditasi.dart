// models/meditation_model.dart
import 'package:flutter/material.dart';

class Meditation {
  final String id;
  final String title;
  final String description;
  final String duration;
  final String category;
  final String emoji;
  final String audioUrl;

  Meditation({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.category,
    required this.emoji,
    this.audioUrl = '',
  });
}
