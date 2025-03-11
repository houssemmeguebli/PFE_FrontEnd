import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:io' show File;
import 'package:path_provider/path_provider.dart';

// Conditional import for web-specific logic
import 'data_exporter_web.dart' if (dart.library.io) 'data_exporter_stub.dart';

class DataExporter {
  /// Parses a timestamp in "DD/MM/YYYY HH:MM:SS" format to DateTime
  static DateTime? _parseTimestamp(String timestamp) {
    try {
      List<String> dateTimeParts = timestamp.split(' '); // Split date and time
      List<String> dateParts = dateTimeParts[0].split('/'); // Split DD/MM/YYYY
      List<String> timeParts = dateTimeParts[1].split(':'); // Split HH:MM:SS

      DateTime dateTime = DateTime(
        int.parse(dateParts[2]), // Year (YYYY)
        int.parse(dateParts[1]), // Month (MM)
        int.parse(dateParts[0]), // Day (DD)
        int.parse(timeParts[0]), // Hour (HH)
        int.parse(timeParts[1]), // Minute (MM)
        int.parse(timeParts[2]), // Second (SS)
      );

      debugPrint("Parsed DateTime: $dateTime from timestamp: $timestamp");
      return dateTime;
    } catch (e) {
      debugPrint('Invalid timestamp format: $timestamp, error: $e');
      return null;
    }
  }

  static Future<void> exportToCsv({
    required List<Map<String, dynamic>> sensorData,
    required BuildContext context,
  }) async {
    debugPrint('Exporting CSV. Data length: ${sensorData.length}');

    if (sensorData.isEmpty) {
      _showSnackBar(context, 'No data available for the last 10 minutes');
      return;
    }

    // Define sensor names and units
    final Map<String, String> sensorUnits = {
      'Tension': 'V',
      'Current': 'A',
      'Torque': 'N·m',
      'Temperature': '°C',
      'Pressure': 'hPa',
      'Vibration': 'm/s²',
      'Speed': 'T/m',
      'Humidity': '%',
      'Efficiency': '%',
      'Push': '',
    };

    // Prepare header row
    final List<String> header = [
      'Time',
      ...sensorUnits.keys.map((name) => '$name (${sensorUnits[name]})'),
    ];

    // Group sensor data by timestamp
    final Map<String, Map<String, double>> groupedData = {};
    final DateTime tenMinutesAgo = DateTime.now().subtract(const Duration(minutes: 10));

    for (var entry in sensorData) {
      final String timestamp = entry['timestamp'] as String;
      final String sensorName = entry['sensor'] as String;
      final double value = (entry['value'] as double);

      debugPrint("Raw timestamp before parsing: $timestamp");

      // Parse timestamp to ensure it's valid and within 10 minutes
      DateTime? dateTime = _parseTimestamp(timestamp);
      if (dateTime == null) {
        debugPrint("Skipping entry due to invalid timestamp: $timestamp");
        continue; // Skip invalid timestamps
      }

      if (dateTime.isAfter(tenMinutesAgo)) {
        groupedData[timestamp] ??= {};
        groupedData[timestamp]![sensorName] = value;
        debugPrint("Added to groupedData: $timestamp -> $sensorName: $value");
      } else {
        debugPrint("Timestamp $timestamp is older than 10 minutes, skipped");
      }
    }

    if (groupedData.isEmpty) {
      _showSnackBar(context, 'No data available for the last 10 minutes');
      return;
    }

    // Prepare CSV data rows
    List<List<dynamic>> csvData = [
      header,
      ...groupedData.entries.map((entry) {
        final timestamp = entry.key;
        final values = entry.value;
        debugPrint("CSV row timestamp: $timestamp");
        return [
          timestamp, // Already in "DD/MM/YYYY HH:MM:SS" format
          ...sensorUnits.keys.map((name) => (values[name] ?? 0.0).toStringAsFixed(3)),
        ];
      }),
    ];

    // Convert to CSV string
    String csv = const ListToCsvConverter().convert(csvData);
    String fileName = 'sensor_data_${DateTime.now().toIso8601String().replaceAll(':', '-')}.csv';

    // Handle CSV export for web and non-web platforms
    if (kIsWeb) {
      exportToCsvWeb(csv, fileName);
      debugPrint('CSV download triggered');
      _showSnackBar(context, 'CSV file downloaded');
    } else {
      await _saveCsvToFile(csv, fileName, context);
    }
  }

  /// Saves CSV to a local file
  static Future<void> _saveCsvToFile(String csv, String fileName, BuildContext context) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(csv);
      debugPrint('CSV saved at: ${file.path}');
      _showSnackBar(context, 'CSV saved at: ${file.path}');
    } catch (e) {
      debugPrint('Error exporting CSV: $e');
      _showSnackBar(context, 'Failed to export CSV');
    }
  }

  /// Displays a Snackbar message
  static void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF109FDB),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}