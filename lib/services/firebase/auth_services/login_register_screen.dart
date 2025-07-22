import 'package:awesome_top_snackbar/awesome_top_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maditrack/Models/person_model.dart';
import 'package:maditrack/Onboarding/onboarding.dart';
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
  bool _isLoading = false;

  // void login() async {
  //   if (emailController.text.trim().isNotEmpty &&
  //       passwordController.text.trim().isNotEmpty) {
  //     try {
  //       await authService.signInWithEmailAndPassword(
  //         emailController.text.trim(),
  //         passwordController.text.trim(),
  //       );
  //       Navigator.pushReplacement(
  //         // ignore: use_build_context_synchronously
  //         context,
  //         MaterialPageRoute(builder: (context) => const MyHomePage()),
  //       );
  //     } on FirebaseAuthException catch (e) {
  //       String errorMessage;
  //       switch (e.code) {
  //         case 'user-not-found':
  //           errorMessage = 'No user found for that email.';
  //           break;
  //         case 'wrong-password':
  //           errorMessage = 'Wrong password provided.';
  //           break;
  //         case 'invalid-email':
  //           errorMessage = 'The email address is not valid.';
  //           break;
  //         default:
  //           errorMessage = 'An error occurred. Please try again.';
  //       }
  //       showInfoSnachBar(errorMessage);
  //     } catch (e) {
  //       showInfoSnachBar('Invalid Credentials, try again!');
  //     }
  //   } else {
  //     showInfoSnachBar('Both fields should be filled!');
  //   }
  // }

  void loginGoogle() async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) =>
            const Center(child: CircularProgressIndicator(color: Colors.red)),
      );
      // Sign in
      User? user = await authService.signInWithGoogle();
      // Close loading
      if (mounted) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      } else {
        return; // Exit if the widget is not mounted
      }
      if (user == null) {
        showErrorSnachBar('Google Sign-In canceled');
        return;
      }
      // Get profile or create it
      PersonModel? profile = await FirebaseDB().getPersonProfile(user.uid);
      if (profile == null) {
        debugPrint('No profile found — creating new one...');
        PersonModel personProfile = PersonModel.fromMap({
          'username': user.displayName ?? 'Unknown',
          'email': user.email ?? 'user@meditrack.com',
          'profilePicture': user.photoURL ?? '',
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
        );
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
  void initState() {
    _isLoading = false;
    super.initState();
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
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                        Text('Google Sign In'),
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
