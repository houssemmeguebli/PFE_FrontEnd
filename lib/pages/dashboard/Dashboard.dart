import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flareline/pages/dashboard/grid_card.dart';
import 'package:flareline/pages/layout.dart';
import '../../_services/data_exporter.dart';
import '../../_services/websocket_service.dart';
import 'SensorDataWidget.dart';

class Dashboard extends LayoutWidget {
  const Dashboard({super.key});

  @override
  String breakTabTitle(BuildContext context) => 'Dashboard';

  @override
  Widget contentDesktopWidget(BuildContext context) => const _DashboardContent();

  @override
  Widget contentMobileWidget(BuildContext context) => const _DashboardContent();
}

class _DashboardContent extends StatefulWidget {
  const _DashboardContent();

  @override
  __DashboardContentState createState() => __DashboardContentState();
}

class __DashboardContentState extends State<_DashboardContent> {
  late WebSocketService _webSocketService;
  final Map<String, double> _sensorValues = {
    "Temperature": 0.0,
    "Pressure": 0.0,
    "Tension": 0.0,
    "Current": 0.0,
    "Torque": 0.0,
    "Vibration": 0.0,
    "Speed": 0.0,
    "Humidity": 0.0,
    "Efficiency": 0.0,
    "Push": 0.0,
  };
  final List<Map<String, dynamic>> _historicalData = [];

  @override
  void initState() {
    super.initState();
    _webSocketService = WebSocketService();
    _setupWebSocketListener();
    debugPrint('WebSocketService initialized with URL: ${_webSocketService.serverUrl}');
  }

  String _formatTimestamp(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}:'
        '${dateTime.second.toString().padLeft(2, '0')}';
  }

  void _setupWebSocketListener() {
    _webSocketService.stream.listen(
          (data) {
        debugPrint('Received WebSocket data: $data');
        if (mounted) {
          setState(() {
            final now = DateTime.now();
            final timestamp = _formatTimestamp(now);

            if (data.containsKey('tension') && data['tension'] is num) {
              _sensorValues["Tension"] = (data['tension'] as num).toDouble();
              _historicalData.add({'sensor': 'Tension', 'value': _sensorValues["Tension"]!, 'timestamp': timestamp});
            }
            if (data.containsKey('current') && data['current'] is num) {
              _sensorValues["Current"] = (data['current'] as num).toDouble();
              _historicalData.add({'sensor': 'Current', 'value': _sensorValues["Current"]!, 'timestamp': timestamp});
            }
            if (data.containsKey('couple') && data['couple'] is num) {
              _sensorValues["Torque"] = (data['couple'] as num).toDouble();
              _historicalData.add({'sensor': 'Torque', 'value': _sensorValues["Torque"]!, 'timestamp': timestamp});
            }
            if (data.containsKey('temperature') && data['temperature'] is num) {
              _sensorValues["Temperature"] = (data['temperature'] as num).toDouble();
              _historicalData.add({'sensor': 'Temperature', 'value': _sensorValues["Temperature"]!, 'timestamp': timestamp});
            }
            if (data.containsKey('saon') && data['saon'] is num) {
              _sensorValues["Pressure"] = (data['saon'] as num).toDouble();
              _historicalData.add({'sensor': 'Pressure', 'value': _sensorValues["Pressure"]!, 'timestamp': timestamp});
            }
            if (data.containsKey('vibration') && data['vibration'] is num) {
              _sensorValues["Vibration"] = (data['vibration'] as num).toDouble();
              _historicalData.add({'sensor': 'Vibration', 'value': _sensorValues["Vibration"]!, 'timestamp': timestamp});
            }
            if (data.containsKey('speed') && data['speed'] is num) {
              _sensorValues["Speed"] = (data['speed'] as num).toDouble();
              _historicalData.add({'sensor': 'Speed', 'value': _sensorValues["Speed"]!, 'timestamp': timestamp});
            }
            if (data.containsKey('pousse') && data['pousse'] is num) {
              _sensorValues["Push"] = (data['pousse'] as num).toDouble();
              _historicalData.add({'sensor': 'Push', 'value': _sensorValues["Push"]!, 'timestamp': timestamp});
            }

            // Remove data older than 10 minutes
            _historicalData.removeWhere((entry) =>
                DateTime.parse(entry['timestamp'].split(' ')[0].split('/').reversed.join('-') + 'T' + entry['timestamp'].split(' ')[1] + 'Z')
                    .isBefore(now.subtract(const Duration(minutes: 10))));
          });
        }
      },
      onError: (error) {
        debugPrint('WebSocket error: $error');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('WebSocket error: $error')),
          );
        }
      },
      onDone: () {
        debugPrint('WebSocket connection closed');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('WebSocket connection closed')),
          );
        }
      },
    );
  }

  Future<void> _exportToCsv() async {
    await DataExporter.exportToCsv(
      sensorData: _historicalData,
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
      {"name": "Torque", "unit": "N·m"},
      {"name": "Vibration", "unit": "m/s²"},
      {"name": "Efficiency", "unit": "%"},
      {"name": "Push", "unit": ""},
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildGrid(sensors),
            const SizedBox(height: 16),
            _buildExportButton(),
            const SizedBox(height: 16),
            _buildSensorDataWidgets(),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(List<Map<String, String>> sensors) {
    return GridView.builder(
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
        final sensorName = sensor["name"]!;
        final sensorValue = _sensorValues[sensorName] ?? 0.0;
        return GridCard(
          name: sensorName,
          unit: sensor["unit"]!,
          value: sensorValue.toStringAsFixed(2),
        );
      },
    );
  }

  Widget _buildExportButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: _exportToCsv,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF109FDB),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          child: const Text(
            'Export CSV',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildSensorDataWidgets() {
    return Column(
      children: [
        _buildSensorRow("Tension"),
        const SizedBox(height: 16),
        _buildSensorRow("Current"),
        const SizedBox(height: 16),
        _buildSensorRow("Torque"),
        const SizedBox(height: 16),
        _buildSensorRow("Temperature"),
        const SizedBox(height: 16),
        _buildSensorRow("Pressure"),
        const SizedBox(height: 16),
        _buildSensorRow("Vibration"),
      ],
    );
  }

  Widget _buildSensorRow(String sensorType) {
    return Row(
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: SensorDataWidget(
            sensorType: sensorType,
            sensorValue: _sensorValues[sensorType] ?? 0.0,
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => _buildDashboardContent();
}