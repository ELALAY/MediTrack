enum Gender { male, female, other }

class PersonModel {
  final String id;
  final String username;
  final String email;
  final String? profilePicture;
  final int? age;
  final double? height; // in cm
  final double? weight; // in kg
  final Gender? gender;
  final List<String>? medicalConditions;
  final List<String>? medications;
  final List<String>? allergies;
  final String? emergencyContact;

  PersonModel({
    required this.username,
    required this.email,
    this.profilePicture,
    this.age,
    this.height,
    this.weight,
    this.gender,
    this.medicalConditions,
    this.medications,
    this.allergies,
    this.emergencyContact,
  }):id = '';

  PersonModel.withId({
    required this.id,
    required this.username,
    required this.email,
    this.profilePicture,
    this.age,
    this.height,
    this.weight,
    this.gender,
    this.medicalConditions,
    this.medications,
    this.allergies,
    this.emergencyContact,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profilePicture': profilePicture,
      'age': age,
      'height': height,
      'weight': weight,
      'gender': gender?.name,
      'medicalConditions': medicalConditions,
      'allergies': allergies,
      'emergencyContact': emergencyContact,
    };
  }

  factory PersonModel.fromMap(Map<String, dynamic> map, String id) {
    return PersonModel.withId(
      id: id,
      username: map['username'],
      email: map['email'],
      profilePicture: map['profilePicture'],
      age: map['age'],
      height: (map['height'] as num?)?.toDouble(),
      weight: (map['weight'] as num?)?.toDouble(),
      gender: _parseGender(map['gender']),
      medicalConditions: List<String>.from(map['medicalConditions'] ?? []),      
      medications: List<String>.from(map['medications'] ?? []),
      allergies: List<String>.from(map['allergies'] ?? []),
      emergencyContact: map['emergencyContact'],
    );
  }

  static Gender? _parseGender(String? value) {
    if (value == null) return null;
    return Gender.values.firstWhere((g) => g.name == value, orElse: () => Gender.other);
  }
}
