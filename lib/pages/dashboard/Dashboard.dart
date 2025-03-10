import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flareline/pages/dashboard/grid_card.dart';
import 'package:flareline/pages/layout.dart';
import '../../_services/data_exporter.dart';
import '../../_services/websocket_service.dart'; // Adjust path
import 'SensorDataWidget.dart';

class Dashboard extends LayoutWidget {
  const Dashboard({super.key});

  @override
  String breakTabTitle(BuildContext context) {
    return 'Dashboard';
  }

  @override
  Widget contentDesktopWidget(BuildContext context) {
    return _DashboardContent();
  }

  @override
  Widget contentMobileWidget(BuildContext context) {
    return _DashboardContent();
  }
}

class _DashboardContent extends StatefulWidget {
  @override
  __DashboardContentState createState() => __DashboardContentState();
}

class __DashboardContentState extends State<_DashboardContent> {
  late WebSocketService _webSocketService;
  List<Map<String, dynamic>> _sensorData = [];

  @override
  void initState() {
    super.initState();
    _webSocketService = WebSocketService();
    _setupWebSocketListener();
    print('WebSocketService initialized with URL: ${_webSocketService.serverUrl}');
  }

  void _setupWebSocketListener() {
    _webSocketService.stream.listen(
          (data) {
        print('Received WebSocket data: $data');
        setState(() {
          final now = DateTime.now();
          final sensorName = data['event'] ?? 'Unknown';
          final sensorValue = data['value'] ?? 0;
          _sensorData.add({
            'timestamp': now,
            'name': sensorName,
            'value': sensorValue,
          });
          _sensorData.removeWhere((entry) =>
              entry['timestamp'].isBefore(now.subtract(const Duration(minutes: 10))));
          print('Updated _sensorData: ${_sensorData.length} entries');
        });
      },
      onError: (error) {
        print('WebSocket error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('WebSocket error: $error')),
        );
      },
      onDone: () {
        print('WebSocket connection closed');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('WebSocket connection closed')),
        );
      },
    );
  }

  Future<void> _exportToCsv() async {
    await DataExporter.exportToCsv(
      sensorData: _sensorData,
      context: context,
    );
  }

  @override
  void dispose() {
    _webSocketService.dispose();
    super.dispose();
  }

  Widget _buildDashboardContent() {
    final List<Map<String, String>> sensors = [
      {"name": "Temperature", "unit": "°C"},
      {"name": "Humidity", "unit": "%"},
      {"name": "Speed", "unit": "T/m"},
      {"name": "Pressure", "unit": "hPa"},
      {"name": "Tension", "unit": "V"},
      {"name": "Current", "unit": "A"},
      {"name": "Torque", "unit": "N"},
      {"name": "Vibration", "unit": ""},
      {"name": "Efficiency", "unit": "%"},
      {"name": "Push", "unit": ""},
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              itemCount: sensors.length,
              itemBuilder: (context, index) {
                final sensor = sensors[index];
                return GridCard(
                  name: sensor["name"]!,
                  unit: sensor["unit"]!,
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Align button to the extreme right
              children: [
                ElevatedButton(
                  onPressed: _exportToCsv,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF109FDB),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // No border radius
                    ),
                  ),
                  child: const Text(
                    'Export CSV',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                Row(
                  children: const [
                    Expanded(child: SensorDataWidget()),
                    SizedBox(width: 16),
                    Expanded(child: SensorDataWidget()),
                    SizedBox(width: 16),
                    Expanded(child: SensorDataWidget()),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: const [
                    Expanded(child: SensorDataWidget()),
                    SizedBox(width: 16),
                    Expanded(child: SensorDataWidget()),
                    SizedBox(width: 16),
                    Expanded(child: SensorDataWidget()),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDashboardContent();
  }
}