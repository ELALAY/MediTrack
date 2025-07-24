import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maditrack/Models/journal_entry.dart';
import 'package:maditrack/Models/medication_model.dart';
import 'package:maditrack/Models/person_model.dart';

class FirebaseDB {
  final _firestore = FirebaseFirestore.instance;

  //--------------------------------------------------
  //----------------- JOURNAL ENTRIES ----------------
  //--------------------------------------------------

  Future<void> addJournalEntry(String uid, JournalEntry entry) async {
    await _firestore
        .collection('persons')
        .doc(uid)
        .collection('journal')
        .doc(entry.id)
        .set(entry.toMap());
  }

  Future<void> updateJournalEntry(String uid, JournalEntry entry) async {
    await _firestore
        .collection('persons')
        .doc(uid)
        .collection('journal')
        .doc(entry.id)
        .update(entry.toMap());
  }

  Future<void> deleteJournalEntry(String uid, String entryId) async {
    await _firestore
        .collection('persons')
        .doc(uid)
        .collection('journal')
        .doc(entryId)
        .delete();
  }

  Future<List<JournalEntry>> getJournalEntries(String uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('journalEntries')
        .where('uid', isEqualTo: uid)
        .orderBy('dateTime', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => JournalEntry.fromMap(doc.data(), doc.id))
        .toList();
  }
  //--------------------------------------------------
  //----------------- PERSON PROFILE -----------------
  //--------------------------------------------------

  Future<void> setPersonProfile(PersonModel person) async {
    await _firestore.collection('persons').doc(person.id).set(person.toMap());
  }

  Future<void> updatePersonProfile(String uid, PersonModel person) async {
    await _firestore.collection('persons').doc(uid).update(person.toMap());
  }

  Future<PersonModel?> getPersonProfile(String uid) async {
    final doc = await _firestore.collection('persons').doc(uid).get();
    if (doc.exists) {
      return PersonModel.fromMap(doc.data()!, uid);
    }
    return null;
  }

  // --------------------------------------------------
  // ----------------- MEDICATIONS --------------------
  // --------------------------------------------------

  Future<void> addMedication(String uid, Medication medication) async {
    await _firestore
        .collection('persons')
        .doc(uid)
        .collection('medications')
        .doc()
        .set(medication.toMap()); // auto-generate ID
  }

  Future<void> updateMedication(String uid, Medication medication) async {
    await _firestore
        .collection('persons')
        .doc(uid)
        .collection('medications')
        .doc(medication.id)
        .update(medication.toMap());
  }

  Future<void> deleteMedication(String uid, String medicationId) async {
    await _firestore
        .collection('persons')
        .doc(uid)
        .collection('medications')
        .doc(medicationId)
        .delete();
  }

  Future<List<Medication>> getMedications(String uid) async {
    final snapshot = await _firestore
        .collection('persons')
        .doc(uid)
        .collection('medications')
        .get();

    return snapshot.docs.map((doc) {
      return Medication.fromMap(doc.data(), doc.id);
    }).toList();
  }
}
