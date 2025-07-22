import 'package:flutter/material.dart';
import 'package:maditrack/Components/my_buttons/my_button.dart';
import 'package:maditrack/Components/my_textfields/my_numberfield.dart';
import 'package:maditrack/Models/person_model.dart';
import 'package:maditrack/Utils/globals.dart';
import 'package:maditrack/home.dart';
import 'package:maditrack/services/firebase/auth_services/auth_service.dart';
import 'package:maditrack/services/firebase/auth_services/login_register_screen.dart';
import 'package:maditrack/services/firebase/fb_database/firebase_database_service.dart';

class OnBoardingScreen extends StatefulWidget {
  final PersonModel personProfile;
  const OnBoardingScreen({super.key, required this.personProfile});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

/* Removed local Gender enum; using Gender from person_model.dart */

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final FirebaseDB fbDatabase = FirebaseDB();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _medicalController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();

  Gender? _selectedGender; // Now using Gender from person_model.dart

  void logout() async {
    await AuthService().signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginOrRegister()),
      );
    }
  }

  void navHomePage() async {
    await AuthService().signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }
  }

  void saveProfileinfo() async {
    try {
      if (_ageController.text.isEmpty ||
          _heightController.text.isEmpty ||
          _weightController.text.isEmpty ||
          _selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please complete all required fields.')),
        );
        return;
      }

      final updatedProfile = PersonModel.withId(
        id: widget.personProfile.id,
        username: widget.personProfile.username,
        email: widget.personProfile.email,
        profilePicture: widget.personProfile.profilePicture,
        age: int.parse(_ageController.text.trim()),
        height: double.parse(_heightController.text.trim()),
        weight: double.parse(_weightController.text.trim()),
        gender: _selectedGender,
        medicalConditions: _medicalController.text.trim().isEmpty
            ? []
            : _medicalController.text
                  .trim()
                  .split(',')
                  .map((e) => e.trim())
                  .toList(),
        allergies: _allergiesController.text.trim().isEmpty
            ? []
            : _allergiesController.text
                  .trim()
                  .split(',')
                  .map((e) => e.trim())
                  .toList(),
      );

      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      // Save to Firestore
      await fbDatabase.setPersonProfile(updatedProfile);

      // Close loading
      if (mounted) Navigator.pop(context);

      // Navigate to home
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MyHomePage()),
        );
      }
    } catch (e) {
      debugPrint('Error saving profile: $e');
      if (mounted) {
        showErrorSnachBar(context, 'Error saving profile');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.blueGrey,
        title: const Text('OnBoarding'),
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'We need the following information for your profile',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Height & Weight
            Row(
              children: [
                Expanded(
                  child: MyNumberField(
                    controller: _heightController,
                    label: 'Height (cm)',
                    color: Colors.red,
                    enabled: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: MyNumberField(
                    controller: _weightController,
                    label: 'Weight (kg)',
                    color: Colors.red,
                    enabled: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Age
            MyNumberField(
              controller: _ageController,
              label: 'Age',
              color: Colors.red,
              enabled: true,
            ),

            const SizedBox(height: 16),

            // Gender Selection
            const Text(
              'Gender',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: const Text('Male'),
              leading: Radio<Gender>(
                value: Gender.male,
                groupValue: _selectedGender,
                onChanged: (Gender? value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Female'),
              leading: Radio<Gender>(
                value: Gender.female,
                groupValue: _selectedGender,
                onChanged: (Gender? value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Other'),
              leading: Radio<Gender>(
                value: Gender.other,
                groupValue: _selectedGender,
                onChanged: (Gender? value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 16),

            // Medical Conditions
            TextField(
              controller: _medicalController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Medical Conditions (Blood Pressure, Diabites ...)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Allergies
            TextField(
              controller: _allergiesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Allergies (Tuna, Pollene ...)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 32),

            // Submit Button
            Center(
              child: MyButton(label: 'Save Profile', onTap: saveProfileinfo),
            ),
          ],
        ),
      ),
    );
  }
}
