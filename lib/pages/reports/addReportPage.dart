import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../../_services/reportService.dart';
import 'package:flareline/pages/layout.dart';

class AddReportPage extends LayoutWidget {
  const AddReportPage({super.key});

  @override
  String breakTabTitle(BuildContext context) => 'Add Report';

  @override
  Widget contentDesktopWidget(BuildContext context) => const _AddReportPageContent();

  @override
  Widget contentMobileWidget(BuildContext context) => const _AddReportPageContent();
}

class _AddReportPageContent extends StatefulWidget {
  const _AddReportPageContent();

  @override
  _AddReportPageContentState createState() => _AddReportPageContentState();
}

class _AddReportPageContentState extends State<_AddReportPageContent> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _createdAtController = TextEditingController();
  final TextEditingController _lastUpdatedAtController = TextEditingController();
  String _reportStatus = 'Pending'; // Default per model
  bool isSubmitting = false;
  final _formKey = GlobalKey<FormState>();
  DateTime? _createdAt;
  DateTime? _lastUpdatedAt;

  @override
  void initState() {
    super.initState();
    // Optional: Set default dates if desired
    _createdAtController.text = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller, DateTime? currentDate, Function(DateTime) onDateSelected) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentDate ?? DateTime.now()),
      );
      if (pickedTime != null) {
        final DateTime fullDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        controller.text = DateFormat('yyyy-MM-dd HH:mm:ss').format(fullDate);
        onDateSelected(fullDate);
      }
    }
  }

  Future<void> submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);

    Map<String, dynamic> reportData = {
      'userId': 1, // Hardcoded to 1 as requested
      'reportContent': _contentController.text,
      'createdAt': _createdAtController.text.isEmpty ? null : _createdAt?.toIso8601String(),
      'lastUpdatedAt': _lastUpdatedAtController.text.isEmpty ? null : _lastUpdatedAt?.toIso8601String(),
      'reportStatus': _reportStatus,
    };

    try {
      bool success = (await ReportService.createReport(reportData)) as bool;
      setState(() => isSubmitting = false);

      if (success) {
        Navigator.pop(context, true); // Trigger fetchReports on ReportPage
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report added successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add report')),
        );
      }
    } catch (e) {
      setState(() => isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(),
                const SizedBox(height: 24),
                _buildFormSection(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: isSubmitting ? null : submitReport,
          backgroundColor: const Color(0xFF109FDB),
          elevation: 6,
          child: isSubmitting
              ? const CircularProgressIndicator(color: Colors.white)
              : const Icon(Icons.save, color: Colors.white, size: 28),
          tooltip: 'Submit Report',
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF109FDB), Color(0xFF66C8F0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Add New Report',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 24),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Cancel',
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User ID: 1', // Display hardcoded userId
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Report Content',
                prefixIcon: const Icon(Icons.description, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Content is required';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _createdAtController,
              decoration: InputDecoration(
                labelText: 'Created At',
                prefixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
              readOnly: true,
              onTap: () => _selectDate(context, _createdAtController, _createdAt, (date) => _createdAt = date),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lastUpdatedAtController,
              decoration: InputDecoration(
                labelText: 'Last Updated At (optional)',
                prefixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
              readOnly: true,
              onTap: () => _selectDate(context, _lastUpdatedAtController, _lastUpdatedAt, (date) => _lastUpdatedAt = date),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _reportStatus,
              items: ['Pending', 'Approved', 'Rejected']
                  .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                  .toList(),
              onChanged: (value) => setState(() => _reportStatus = value!),
              decoration: InputDecoration(
                labelText: 'Status',
                prefixIcon: const Icon(Icons.label, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
            ),
            const SizedBox(height: 20),
            if (isSubmitting)
              const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Color(0xFF109FDB))))
          ],
        ),
      ),
    );
  }
}