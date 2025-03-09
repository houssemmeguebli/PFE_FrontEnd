import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/python.dart';

class CodeEditorWidget extends StatelessWidget {
  final CodeController controller;

  const CodeEditorWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
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
      child: CodeTheme(
        data: CodeThemeData(styles: {
          'keyword': TextStyle(color: Colors.blue.shade400),
          'string': TextStyle(color: Colors.green.shade400),
          'comment': TextStyle(color: Colors.grey.shade500),
          'number': TextStyle(color: Colors.orange.shade400),
        }),
        child: CodeField(
          controller: controller,
          textStyle: const TextStyle(fontFamily: 'Monospace', fontSize: 14),
          gutterStyle: const GutterStyle(
            showLineNumbers: true,
            textStyle: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      ),
    );
  }
}