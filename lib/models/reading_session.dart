class ReadingSession {
  final String id;
  final DateTime date;
  final int pages;
  final int minutes;
  final String format;

  const ReadingSession({
    required this.id,
    required this.date,
    required this.pages,
    required this.minutes,
    required this.format,
  });

  factory ReadingSession.fromMap(String id, Map<String, dynamic> map) {
    return ReadingSession(
      id: id,
      date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      pages: (map['pages'] as num?)?.toInt() ?? 0,
      minutes: (map['minutes'] as num?)?.toInt() ?? 0,
      format: map['format'] as String? ?? 'Físico',
    );
  }

  Map<String, dynamic> toMap() => {
        'date': date.toIso8601String(),
        'pages': pages,
        'minutes': minutes,
        'format': format,
      };
}
