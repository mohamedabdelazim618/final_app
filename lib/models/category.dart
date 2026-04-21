class Category {
  final int id;
  final String title;
  final String audioUrl;
  final String textUrl;

  const Category({
    required this.id, required this.title,
    required this.audioUrl, required this.textUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['ID'] as int,
    title: json['TITLE'] as String,
    audioUrl: json['AUDIO_URL'] as String? ?? '',
    textUrl: json['TEXT'] as String,
  );

  String get iconEmoji {
    const icons = {
      27: '🌅', 28: '🌙', 1: '☀️', 6: '🚪', 7: '🚿',
      8: '💧', 9: '✨', 10: '🏠', 11: '🏡', 12: '🕌',
      13: '🕌', 14: '🕌', 15: '📢', 16: '🙏', 17: '🧎',
      18: '🧎', 19: '🤲', 20: '🤲', 21: '📖', 22: '📿',
      23: '🌿', 24: '🤲', 25: '📿', 26: '🤲', 29: '🌃',
      30: '😨', 31: '💭', 32: '🌙', 33: '📿', 34: '💙',
      35: '🌊', 41: '💰', 68: '🌙', 69: '🍽️', 70: '🍽️',
      79: '💍', 95: '🚗', 96: '✈️', 129: '🙏', 130: '📿',
    };
    return icons[id] ?? '📿';
  }
}
