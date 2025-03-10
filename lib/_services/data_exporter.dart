import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:io' show File;
import 'package:path_provider/path_provider.dart';

// Conditional import for web-specific logic
import 'data_exporter_web.dart' if (dart.library.io) 'data_exporter_stub.dart';

class DataExporter {
  // Export data to CSV for the last 10 minutes
  static Future<void> exportToCsv({
    required List<Map<String, dynamic>> sensorData,
    required BuildContext context,
  }) async {
    print('Exporting CSV. Data length: ${sensorData.length}');
    if (sensorData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No data available for the last 10 minutes',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    }

    // Prepare CSV data
    List<List<dynamic>> csvData = [
      ['Timestamp', 'Sensor Name', 'Value'],
      ...sensorData.map((entry) => [
        entry['timestamp'].toIso8601String(),
        entry['name'],
        entry['value'],
      ]),
    ];

    // Convert to CSV string
    String csv = const ListToCsvConverter().convert(csvData);
    String fileName = 'sensor_data_${DateTime.now().toIso8601String().replaceAll(':', '-')}.csv';

    if (kIsWeb) {
      // Web: Trigger browser download
      exportToCsvWeb(csv, fileName); // Call web-specific function

      print('CSV download triggered');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF109FDB), // Cyan background
          content: Text(
            'CSV file downloaded',
            style: TextStyle(color: Colors.white), // White text
          ),
        ),
      );
    } else {
      // Desktop and Mobile: Save to filesystem
      try {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$fileName');
        await file.writeAsString(csv);

        print('CSV saved at: ${file.path}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF109FDB), // Cyan background
            content: Text(
              'CSV saved at: ${file.path}',
              style: const TextStyle(color: Colors.white), // White text
            ),
          ),
        );
      } catch (e) {
        print('Error exporting CSV: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to export CSV',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    }
  }
}