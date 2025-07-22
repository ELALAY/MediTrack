import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maditrack/Models/person_model.dart';
import 'package:maditrack/services/firebase/auth_services/auth_service.dart';
import 'package:maditrack/services/firebase/auth_services/login_register_screen.dart';
import 'package:maditrack/services/firebase/fb_database/firebase_database_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseDB firebaseDb = FirebaseDB();
  AuthService _authService = AuthService();
  // User Info
  User? user;
  PersonModel? personProfile;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.blueGrey,
        title: Text('MediTrack'),
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
    );
  }
}
