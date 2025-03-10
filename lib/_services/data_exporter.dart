import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:io' show File;
import 'package:path_provider/path_provider.dart';

// Conditional import for web-specific logic
import 'data_exporter_web.dart' if (dart.library.io) 'data_exporter_stub.dart';

class DataExporter {
  static Future<void> exportToCsv({
    required List<Map<String, dynamic>> sensorData,
    required BuildContext context,
  }) async {
    debugPrint('Exporting CSV. Data length: ${sensorData.length}');
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

    // Define sensor names and units
    final sensorUnits = {
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
    final header = [
      'Time',
      ...sensorUnits.keys.map((name) => '$name (${sensorUnits[name]})'),
    ];

    // Group sensor data by timestamp
    final Map<String, Map<String, double>> groupedData = {};
    final tenMinutesAgo = DateTime.now().subtract(const Duration(minutes: 10));

    for (var entry in sensorData) {
      final timestamp = entry['timestamp'] as String;
      final sensorName = entry['sensor'] as String;
      final value = (entry['value'] as double);

      // Parse custom timestamp back to DateTime for filtering
      final dateParts = timestamp.split(' ')[0].split('/');
      final timeParts = timestamp.split(' ')[1].split(':');
      final dateTime = DateTime(
        int.parse(dateParts[2]), // yyyy
        int.parse(dateParts[1]), // mm
        int.parse(dateParts[0]), // dd
        int.parse(timeParts[0]), // hh
        int.parse(timeParts[1]), // mm
        int.parse(timeParts[2]), // ss
      );

      if (dateTime.isAfter(tenMinutesAgo)) {
        groupedData[timestamp] ??= {};
        groupedData[timestamp]![sensorName] = value;
      }
    }

    if (groupedData.isEmpty) {
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

    // Prepare CSV data rows
    List<List<dynamic>> csvData = [
      header,
      ...groupedData.entries.map((entry) {
        final timestamp = entry.key;
        final values = entry.value;
        return [
          timestamp,
          ...sensorUnits.keys.map((name) => (values[name] ?? 0.0).toStringAsFixed(2)),
        ];
      }),
    ];

    // Convert to CSV string
    String csv = const ListToCsvConverter().convert(csvData);
    String fileName = 'sensor_data_${DateTime.now().toIso8601String().replaceAll(':', '-')}.csv';

    if (kIsWeb) {
      exportToCsvWeb(csv, fileName);
      debugPrint('CSV download triggered');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF109FDB),
          content: Text(
            'CSV file downloaded',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$fileName');
        await file.writeAsString(csv);
        debugPrint('CSV saved at: ${file.path}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF109FDB),
            content: Text(
              'CSV saved at: ${file.path}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      } catch (e) {
        debugPrint('Error exporting CSV: $e');
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