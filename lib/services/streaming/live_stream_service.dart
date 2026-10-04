class LiveStreamService {
  bool _isStreaming = false;
  String? _currentStreamUrl;

  Future<String> createStream(String gameId, String title) async {
    _currentStreamUrl = 'livekit://game/$gameId';
    return _currentStreamUrl!;
  }

  Future<bool> startStreaming(String streamUrl) async {
    _isStreaming = true;
    return true;
  }

  Future<void> endStream(String streamUrl) async {
    _isStreaming = false;
    _currentStreamUrl = null;
  }

  Future<bool> createWatchParty(String gameId, String hostId) async {
    return true;
  }

  Future<String> generateCommentary(String eventType, String playerName) async {
    final comments = {
      'correct_answer': [
        '$playerName knows their stuff!',
        'Unbelievable knowledge from $playerName!',
        '$playerName is on fire tonight!',
      ],
      'wrong_answer': [
        'Oh no, $playerName! That was a tough one!',
        '$playerName misses!',
        'Even the best slip up sometimes, $playerName!',
      ],
      'speed_answer': [
        '$playerName answered that in record time!',
        'Lightning reflexes from $playerName!',
      ],
      'streak': [
        '$playerName is on a streak! Can anyone stop them?',
        'This is incredible, $playerName is unstoppable!',
      ],
    };

    final pool = comments[eventType] ?? ['What a moment!'];
    return pool[DateTime.now().millisecond % pool.length];
  }

  bool get isStreaming => _isStreaming;

  void dispose() {
    _isStreaming = false;
    _currentStreamUrl = null;
  }
}
