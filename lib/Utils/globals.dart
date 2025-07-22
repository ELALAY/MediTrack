import 'package:awesome_top_snackbar/awesome_top_snackbar.dart';
import 'package:flutter/material.dart';

void showErrorSnachBar(BuildContext context, String message) {
  awesomeTopSnackbar(
    context,
    message,
    iconWithDecoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white),
      color: Colors.red.shade400,
    ),
    backgroundColor: Colors.red,
    icon: const Icon(Icons.close, color: Colors.white),
  );
}

void showWarningSnachBar(BuildContext context, String message) {
  awesomeTopSnackbar(
    context,
    message,
    iconWithDecoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white),
      color: Colors.amber.shade400,
    ),
    backgroundColor: Colors.amber,
    icon: const Icon(Icons.warning_amber, color: Colors.white),
  );
}

void showInfoSnachBar(BuildContext context, String message) {
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

void showSuccessSnachBar(BuildContext context, String message) {
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

final List<Color> colorOptions = [
  Colors.red,
  Colors.green,
  Colors.blueGrey,
  Colors.deepOrange,
  Colors.deepPurple,
  Colors.cyan,
  Colors.pink,
  Color(0xFF001F54), // navyBlue
];

const Color navyBlue = Color(0xFF001F54);
