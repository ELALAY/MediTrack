class SymptomLog {
  final String id;
  final String name;
  final int severity; // 1-5 scale
  final String notes;
  final DateTime dateTime;

  SymptomLog({
    required this.id,
    required this.name,
    required this.severity,
    required this.notes,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'severity': severity,
    'notes': notes,
    'dateTime': dateTime.toIso8601String(),
  };

  factory SymptomLog.fromMap(Map<String, dynamic> map) => SymptomLog(
    id: map['id'],
    name: map['name'],
    severity: map['severity'],
    notes: map['notes'],
    dateTime: DateTime.parse(map['dateTime']),
  );
}
