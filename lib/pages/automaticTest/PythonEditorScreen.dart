import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/python.dart';
import '../layout.dart';
import 'CodeEditorWidget.dart';
import 'console_output_widget.dart';


class PythonEditorScreen extends LayoutWidget {
  const PythonEditorScreen({super.key});

  @override
  String breakTabTitle(BuildContext context) {
    return 'Python Editor';
  }

  @override
  Widget contentDesktopWidget(BuildContext context) {
    return _PythonEditorContent();
  }

  @override
  Widget contentMobileWidget(BuildContext context) {
    return _PythonEditorContent();
  }
}

class _PythonEditorContent extends StatefulWidget {
  @override
  State<_PythonEditorContent> createState() => _PythonEditorContentState();
}

class _PythonEditorContentState extends State<_PythonEditorContent> {
  String output = "";
  bool isRunning = false;
  bool isDebugging = false;
  final _codeController = CodeController(
    text: "print('Hello, Python!')\n# Syntax error example: missing parenthesis",
    language: python,
  );

  Future<void> runScript() async {
    setState(() {
      isRunning = true;
      output = "Running script...\n";
    });

    // Simulate script execution
    await Future.delayed(const Duration(seconds: 2));

    // Simulate output
    setState(() {
      isRunning = false;
      output += "Hello, Python!\nScript executed successfully!\n";
    });
  }

  void debugScript() async {
    setState(() {
      isDebugging = true;
      output = "Debugging script...\n";
    });

    // Simulate debugging steps
    for (int i = 1; i <= 3; i++) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        output += "Step $i: Executing line $i...\n";
      });
    }

    setState(() {
      isDebugging = false;
      output += "Debugging completed.\n";
    });
  }

  void stopScript() {
    setState(() {
      isRunning = false;
      isDebugging = false;
      output += "Execution stopped.\n";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Python Script Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: isRunning || isDebugging ? null : runScript,
            tooltip: 'Run Script',
          ),
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: isRunning || isDebugging ? null : debugScript,
            tooltip: 'Debug Script',
          ),
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: isRunning || isDebugging ? stopScript : null,
            tooltip: 'Stop Execution',
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: CodeEditorWidget(controller: _codeController),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            flex: 1,
            child: ConsoleOutputWidget(output: output),
          ),
        ],
      ),
    );
  }
}