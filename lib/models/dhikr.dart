class Dhikr {
  final int id;
  final String arabicText;
  final String translatedText;
  final int repeat;
  final String audioUrl;

  const Dhikr({
    required this.id, required this.arabicText,
    required this.translatedText, required this.repeat, required this.audioUrl,
  });

  factory Dhikr.fromJson(Map<String, dynamic> json) => Dhikr(
    id: json['ID'] as int,
    arabicText: json['ARABIC_TEXT'] as String? ?? '',
    translatedText: json['TRANSLATED_TEXT'] as String? ?? '',
    repeat: json['REPEAT'] as int? ?? 1,
    audioUrl: json['AUDIO'] as String? ?? '',
  );
}
