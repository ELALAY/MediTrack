import 'package:awesome_top_snackbar/awesome_top_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maditrack/Models/person_model.dart';
import 'package:maditrack/home.dart';
import 'package:maditrack/services/firebase/fb_database/firebase_database_service.dart';
import 'auth_service.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  void login() async {
    if (emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty) {
      try {
        await authService.signInWithEmailAndPassword(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found for that email.';
            break;
          case 'wrong-password':
            errorMessage = 'Wrong password provided.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          default:
            errorMessage = 'An error occurred. Please try again.';
        }
        showInfoSnachBar(errorMessage);
      } catch (e) {
        showInfoSnachBar('Invalid Credentials, try again!');
      }
    } else {
      showInfoSnachBar('Both fields should be filled!');
    }
  }

  void loginGoogle() async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: Colors.red),
        ),
      );
      // Sign in
      User? user = await authService.signInwithGoogle();
      // Close loading
      if(mounted) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      } else {
        return; // Exit if the widget is not mounted
      }
      Navigator.of(context).pop();
      if (user == null) {
        showErrorSnachBar('Google Sign-In canceled');
        return;
      }
      // Get profile or create it
      PersonModel? profile = await FirebaseDB().getPersonProfile(user.uid);
      if (profile == null) {
        debugPrint('No profile found — creating new one...');
        PersonModel personProfile = PersonModel.fromMap({
          'username': user.displayName,
          'email':user.email,
          'profilePicture': user.photoURL
          
        }, user.uid);

        await FirebaseFirestore.instance
            .collection('persons')
            .doc(user.uid)
            .set(personProfile.toMap());

        showInfoSnachBar('Welcome ${user.displayName}, profile created!');
      } else {
        showSuccessSnachBar('Welcome back, ${profile.username}!');
      }

      // Navigate to onboarding or home
      if (mounted) {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        // );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
      } // Close dialog on error
      debugPrint('Google sign-in error: $e');
      showErrorSnachBar('Error signing in with Google. Try again.');
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            SizedBox(height: 150, child: Image.asset('lib/Images/login.gif')),
            const SizedBox(height: 20),
            const Text(
              'Personal Wallet Tracker',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: (){},
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not a member?'),
                  SizedBox(width: 5),
                  Text(
                    'Register Now!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: loginGoogle,
              child: Container(
                height: 100.0,
                width: 100.0,
                // padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red, width: 2.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset.fromDirection(1, 2),
                      blurRadius: 2.0,
                    ),
                  ],
                ),
                child: Image.asset(
                  'lib/Images/google_icon.png',
                  // color: Colors.white,
                ),
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
