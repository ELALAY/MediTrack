import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maditrack/Components/my_textfields/my_textfield.dart';
import 'package:maditrack/Models/journal_entry.dart';
import 'package:maditrack/Models/medication_model.dart';
import 'package:maditrack/Models/person_model.dart';
import 'package:maditrack/services/firebase/fb_database/firebase_database_service.dart';

class LogJournalEntryScreen extends StatefulWidget {
  final PersonModel personProfile;

  const LogJournalEntryScreen({required this.personProfile, super.key});

  @override
  State<LogJournalEntryScreen> createState() => _LogJournalEntryScreenState();
}

class _LogJournalEntryScreenState extends State<LogJournalEntryScreen> {
  final FirebaseDB firebaseDB = FirebaseDB();
  List<Medication> medications = [];
  Medication? selectedMedication;
  DateTime selectedDateTime = DateTime.now();
  final TextEditingController commentController = TextEditingController();

  Future<void> _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      // ignore: use_build_context_synchronously
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
    );
    if (pickedTime == null) return;

    setState(() {
      selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> _saveEntry() async {
    if (selectedMedication == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select a medication."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final entry = JournalEntry(
      uid: widget.personProfile.id,
      medicationId: selectedMedication!.id,
      medicationName: selectedMedication!.name,
      comment: commentController.text.trim(),
      dateTime: selectedDateTime,
    );

    await firebaseDB.addJournalEntry(widget.personProfile.id, entry);
    if (mounted) {
      Navigator.pop(context); // close the screen after saving
    }
  }

  @override
  void initState() {
    getMedications();
    super.initState();
  }

  void getMedications() async {
    try {
      List<Medication> medicationsList = await firebaseDB.getMedications(
        widget.personProfile.id,
      );
      setState(() {
        medications = medicationsList;
      });
    } catch (e) {
      debugPrint('=== Error fetching medications');
    }
  }

  void addMedication() async {
    final nameController = TextEditingController();
    final dosageController = TextEditingController();
    final notesController = TextEditingController();
    Frequency selectedFrequency = Frequency.daily;
    final times = <String>['08:00', '14:00', '20:00']; // Default times

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Medication"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyTextField(
                  controller: nameController,
                  label: 'Name',
                  color: Colors.red.shade800,
                  enabled: true,
                ),
                SizedBox(height: 12),
                MyTextField(
                  controller: dosageController,
                  label: 'Dosage (e.g. 500mg)',
                  color: Colors.red.shade800,
                  enabled: true,
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<Frequency>(
                  value: selectedFrequency,
                  decoration: InputDecoration(
                    labelText: "Frequency",
                    labelStyle: TextStyle(color: Colors.red.shade800),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red.shade800),
                    ),
                  ),
                  items: Frequency.values
                      .map(
                        (freq) => DropdownMenuItem(
                          value: freq,
                          child: Text(freq.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedFrequency = value;
                    }
                  },
                ),
                SizedBox(height: 12),
                MyTextField(
                  controller: notesController,
                  label: 'Notes (optional)',
                  color: Colors.red.shade800,
                  enabled: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("Add"),
              onPressed: () async {
                final name = nameController.text.trim();
                final dosage = dosageController.text.trim();

                if (name.isEmpty || dosage.isEmpty) return;

                final newMed = Medication(
                  name: name,
                  dosage: dosage,
                  times: times,
                  frequency: selectedFrequency,
                  isActive: true,
                  notes: notesController.text.trim(),
                );

                await firebaseDB.addMedication(widget.personProfile.id, newMed);
                Navigator.pop(context);
                getMedications(); // Refresh the dropdown list
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log Medication Entry"),
        actions: [IconButton(onPressed: _saveEntry, icon: Icon(Icons.check))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<Medication>(
                      decoration: InputDecoration(
                        hint: Text('Select Medication'),
                        hintStyle: TextStyle(
                          color: Colors.red.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                        suffixIcon: Icon(Icons.medication_outlined),
                        suffixIconColor: Colors.red.shade800,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red.shade800),
                        ),
                        labelText: 'Medications',
                        labelStyle: TextStyle(color: Colors.red.shade800),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red.shade800),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red.shade800),
                        ),
                      ),
                      hint: Text("Select Medication"),
                      value: selectedMedication,
                      items: medications
                          .map(
                            (med) => DropdownMenuItem(
                              value: med,
                              child: Text(med.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedMedication = value),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      Icons.medical_services_rounded,
                      color: Colors.red.shade800,
                    ),
                    tooltip: 'Add new medication',
                    onPressed: addMedication,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            ListTile(
              title: Text(
                DateFormat('yMMMd – hh:mm a').format(selectedDateTime),
                style: TextStyle(
                  color: Colors.red.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Icon(Icons.calendar_month, color: Colors.red.shade800),
              onTap: _pickDateTime,
            ),
            const SizedBox(height: 16),
            MyTextField(
              controller: commentController,
              label: 'Comment (Optional)',
              color: Colors.red.shade800,
              enabled: true,
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _saveEntry,
              icon: Icon(Icons.save),
              label: Text("Save Entry"),
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
            ),
          ],
        ),
      ),
    );
  }
}
