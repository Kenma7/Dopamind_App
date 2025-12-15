class MusicPlayerState {
  final bool isPlaying;
  final Duration currentPosition;
  final Duration totalDuration;
  final String currentTrackId;

  MusicPlayerState({
    this.isPlaying = false,
    this.currentPosition = Duration.zero,
    this.totalDuration = Duration.zero,
    this.currentTrackId = '',
  });

  MusicPlayerState copyWith({
    bool? isPlaying,
    Duration? currentPosition,
    Duration? totalDuration,
    String? currentTrackId,
  }) {
    return MusicPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentPosition: currentPosition ?? this.currentPosition,
      totalDuration: totalDuration ?? this.totalDuration,
      currentTrackId: currentTrackId ?? this.currentTrackId,
    );
  }
}
