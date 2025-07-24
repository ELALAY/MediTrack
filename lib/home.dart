import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maditrack/Models/journal_entry.dart';
import 'package:maditrack/Models/person_model.dart';
import 'package:maditrack/Screens/new_journal_entry_screen.dart';
import 'package:maditrack/Utils/globals.dart';
import 'package:maditrack/services/firebase/auth_services/auth_service.dart';
import 'package:maditrack/services/firebase/auth_services/login_register_screen.dart';
import 'package:maditrack/services/firebase/fb_database/firebase_database_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseDB firebaseDb = FirebaseDB();
  final AuthService _authService = AuthService();
  // User Info
  User? user;
  PersonModel? personProfile;
  List<JournalEntry> entries = [];
  bool _isLoading = false;

  void logout() async {
    await AuthService().signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginOrRegister()),
      );
    }
  }

  @override
  void initState() {
    _isLoading = true;
    fetchUser();
    _isLoading = false;
    super.initState();
  }

  void fetchUser() async {
    try {
      User? userTemp = _authService.getCurrentUser();
      if (userTemp != null) {
        PersonModel? p = await firebaseDb.getPersonProfile(userTemp.uid);

        if (p != null) {
          setState(() {
            user = userTemp;
            personProfile = p;
          });

          List<JournalEntry> journal = await firebaseDb.getJournalEntries(p.id);

          setState(() {
            entries = journal;
          });

        } else {
          debugPrint('=== Error getting profile');
          if (mounted) {
            showErrorSnachBar(context, 'Error getting profule');
          }
        }
      } else {
        showErrorSnachBar(context, "Can't get user!");
        debugPrint('=== Error getting User');
      }
    } catch (e) {
      debugPrint('=== Error getting profile: $e');
      if (mounted) {
        showErrorSnachBar(context, 'Error getting profule');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.blueGrey,
        title: personProfile != null
            ? Text(personProfile!.username)
            : Text('MediTrack'),
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.red.shade800,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Entries'),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.more_horiz_outlined),
                      ),
                    ],
                  ),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ,
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToJournal,
        backgroundColor: Colors.red,
        child: Icon(Icons.receipt_long, color: Colors.white70),
      ),
    );
  }

  void _navigateToJournal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LogJournalEntryScreen(personProfile: personProfile!),
      ),
    );
  }
}
