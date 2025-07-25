import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final Color color;
  final bool enabled;
  final int? minLines;
  final int? maxLines;

  const MyTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.color,
    required this.enabled,
    this.minLines,
    this.maxLines,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: widget.controller,
        enabled: widget.enabled,
        minLines: 3,
        maxLines: 6,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hint: Text(widget.label),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: widget.color),
          ),
          labelText: widget.label,
          labelStyle: TextStyle(color: widget.color),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.color),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.color),
          ),
        ),
      ),
    );
  }
}
