import 'package:awesome_top_snackbar/awesome_top_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maditrack/Models/person_model.dart';
import 'package:maditrack/Onboarding/onboarding.dart';
import 'package:maditrack/home.dart';
import 'package:maditrack/services/firebase/fb_database/firebase_database_service.dart';
import 'auth_service.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  final AuthService authService = AuthService();
  bool _isLoading = false;

  void loginGoogle() async {
    try {
      setState(() => _isLoading = true);

      User? user = await authService.signInWithGoogle();

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (user == null) {
        showErrorSnachBar('Google Sign-In canceled');
        return;
      }

      final firebaseDB = FirebaseDB();
      PersonModel? profile = await firebaseDB.getPersonProfile(user.uid);

      if (profile == null) {
        debugPrint('No profile found — creating new one...');
        PersonModel newProfile = PersonModel.fromMap({
          'username': user.displayName ?? 'Unknown',
          'email': user.email ?? 'user@meditrack.com',
          'profilePicture': user.photoURL ?? '',
        }, user.uid);

        await FirebaseFirestore.instance
            .collection('persons')
            .doc(user.uid)
            .set(newProfile.toMap());

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => OnBoardingScreen(personProfile: newProfile),
            ),
          );
        }

        showInfoSnachBar('Welcome ${user.displayName}, profile created!');
      } else {
        showSuccessSnachBar('Welcome back, ${profile.username}!');
        // You can navigate to home screen here if already onboarded
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => MyHomePage(),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Google sign-in error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        showErrorSnachBar('Error signing in with Google. Try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  SizedBox(
                    height: 150,
                    child: Image.asset('lib/Images/login.gif'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'MediTrack',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  const SizedBox(height: 60),
                  ElevatedButton(
                    onPressed: loginGoogle,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                          child: Image.asset('lib/Images/google_icon.png'),
                        ),
                        const SizedBox(width: 10),
                        const Text('Google Sign In'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void showErrorSnachBar(String message) {
    awesomeTopSnackbar(
      context,
      message,
      iconWithDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
        color: Colors.amber.shade400,
      ),
      backgroundColor: Colors.amber,
      icon: const Icon(Icons.close, color: Colors.white),
    );
  }

  void showInfoSnachBar(String message) {
    awesomeTopSnackbar(
      context,
      message,
      iconWithDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
        color: Colors.lightBlueAccent.shade400,
      ),
      backgroundColor: Colors.lightBlueAccent,
      icon: const Icon(Icons.info_outline, color: Colors.white),
    );
  }

  void showSuccessSnachBar(String message) {
    awesomeTopSnackbar(
      context,
      message,
      iconWithDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
        color: Colors.green.shade400,
      ),
      backgroundColor: Colors.green,
      icon: const Icon(Icons.check, color: Colors.white),
    );
  }
}
