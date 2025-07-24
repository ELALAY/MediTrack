enum Frequency { daily, weekly, monthly, trimesterly, semeterly }

class Medication {
  final String id;
  final String name; //e.g. 500mg
  final String dosage;
  final List<String> times; // e.g. ["08:00", "14:00"]
  final Frequency frequency; // e.g. daily, weekly
  final bool isActive;
  final String notes;

  Medication({
    required this.name,
    required this.dosage,
    required this.times,
    required this.frequency,
    required this.isActive,
    required this.notes,
  }) : id = '';

  Medication.withId({
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
    'frequency': frequency.name,
    'isActive': isActive,
    'notes': notes,
  };

  factory Medication.fromMap(Map<String, dynamic> map, String id) =>
      Medication.withId(
        id: id,
        name: map['name'],
        dosage: map['dosage'],
        times: List<String>.from(map['times']),
        frequency: Frequency.values.firstWhere(
          (e) => e.name == map['frequency'],
          orElse: () => Frequency.daily,
        ),
        isActive: map['isActive'],
        notes: map['notes'],
      );
}
