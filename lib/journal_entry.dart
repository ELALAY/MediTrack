class JournalEntry {
  final String id;
  final String text;
  final DateTime dateTime;

  JournalEntry({
    required this.id,
    required this.text,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'],
      text: map['text'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }
}
