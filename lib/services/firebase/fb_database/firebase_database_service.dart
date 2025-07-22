import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maditrack/Models/person_model.dart';
import 'package:maditrack/journal_entry.dart';

class FirebaseDB {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;


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

  //--------------------------------------------------
  //----------------- PERSON PROFILE -----------------
  //--------------------------------------------------

  Future<void> setPersonProfile(String uid, PersonModel person) async {
    await _firestore.collection('persons').doc(uid).set(person.toMap());
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
}
