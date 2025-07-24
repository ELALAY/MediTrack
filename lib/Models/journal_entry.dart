class JournalEntry {
  final String id;
  final String uid;
  final String medicationId;
  final String medicationName;
  final String comment; // optional comment
  final DateTime dateTime; // time medication was taken

  JournalEntry({
    required this.uid,
    required this.medicationId,
    required this.medicationName,
    required this.comment,
    required this.dateTime,
  }) : id = '';
  JournalEntry.withId({
    required this.id,
    required this.uid,
    required this.medicationId,
    required this.medicationName,
    required this.comment,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'medicationId': medicationId,
      'medicationName': medicationName,
      'comment': comment,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map, String id) {
    return JournalEntry.withId(
      id: id,
      uid:map['uid'],
      medicationId: map['medicationId'],
      medicationName: map['medicationName'],
      comment: map['comment'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }
}
