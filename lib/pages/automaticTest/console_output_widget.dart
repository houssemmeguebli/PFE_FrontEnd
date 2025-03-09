import 'package:flutter/material.dart';

class ConsoleOutputWidget extends StatelessWidget {
  final String output;

  const ConsoleOutputWidget({super.key, required this.output});

  @override
  Widget build(BuildContext context) {
    // Split the output into lines and keep only the last 20 lines
    final lines = output.split('\n');
    final recentLines = lines.length > 20 ? lines.sublist(lines.length - 20) : lines;
    final recentOutput = recentLines.join('\n');

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Scrollbar(
        child: SingleChildScrollView(
          reverse: true, // Scroll to the bottom
          child: Text(
            recentOutput,
            style: const TextStyle(color: Colors.green, fontSize: 14),
          ),
        ),
      ),
    );
  }
}