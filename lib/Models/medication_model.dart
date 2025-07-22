class Medication {
  final String id;
  final String name;
  final String dosage;
  final List<String> times; // e.g. ["08:00", "14:00"]
  final String frequency; // e.g. daily, weekly
  final bool isActive;
  final String notes;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.times,
    required this.frequency,
    required this.isActive,
    required this.notes,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'dosage': dosage,
    'times': times,
    'frequency': frequency,
    'isActive': isActive,
    'notes': notes,
  };

  factory Medication.fromMap(Map<String, dynamic> map) => Medication(
    id: map['id'],
    name: map['name'],
    dosage: map['dosage'],
    times: List<String>.from(map['times']),
    frequency: map['frequency'],
    isActive: map['isActive'],
    notes: map['notes'],
  );
}
