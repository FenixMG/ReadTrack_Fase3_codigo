class Book {
  final String id;
  final String title;
  final String author;
  final int totalPages;
  final int currentPage;
  final String genre;
  final String format;
  final DateTime startDate;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.totalPages,
    required this.currentPage,
    required this.genre,
    required this.format,
    required this.startDate,
  });

  double get progress =>
      totalPages == 0 ? 0 : (currentPage / totalPages).clamp(0, 1);

  factory Book.fromMap(String id, Map<String, dynamic> map) {
    return Book(
      id: id,
      title: map['title'] as String? ?? '',
      author: map['author'] as String? ?? '',
      totalPages: (map['totalPages'] as num?)?.toInt() ?? 0,
      currentPage: (map['currentPage'] as num?)?.toInt() ?? 0,
      genre: map['genre'] as String? ?? '',
      format: map['format'] as String? ?? 'Físico',
      startDate: DateTime.tryParse(map['startDate'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'author': author,
        'totalPages': totalPages,
        'currentPage': currentPage,
        'genre': genre,
        'format': format,
        'startDate': startDate.toIso8601String(),
      };
}
