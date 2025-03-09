import 'package:flareline/core/theme/global_colors.dart';
import 'package:flareline/_services/websocket_service.dart';
import 'package:flutter/material.dart';
import 'package:flareline_uikit/components/card/common_card.dart';
import 'package:responsive_builder/responsive_builder.dart';

class GridCard extends StatefulWidget {
  final String name;
  final String unit;

  const GridCard({super.key, required this.name, required this.unit});

  @override
  _GridCardState createState() => _GridCardState();
}

class _GridCardState extends State<GridCard> {
  final WebSocketService _webSocketService = WebSocketService();
  String sensorValue = "0"; // Default value before data arrives

  @override
  void initState() {
    super.initState();
    _webSocketService.stream.listen((data) {
      if (data.containsKey('event') && data['event'] == 'randomValue') {
        setState(() {
          sensorValue = _formatSensorValue(widget.name, data['value']);
        });
      }
    });
  }

  @override
  void dispose() {
    _webSocketService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      desktop: contentDesktopWidget,
      mobile: contentMobileWidget,
      tablet: contentMobileWidget,
    );
  }

  Widget contentDesktopWidget(BuildContext context) {
    return _itemCardWidget(context, widget.name, sensorValue, widget.unit);
  }

  Widget contentMobileWidget(BuildContext context) {
    return _itemCardWidget(context, widget.name, sensorValue, widget.unit);
  }

  Widget _itemCardWidget(BuildContext context, String name, String value, String unit) {
    return CommonCard(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Sensor Icon
            ClipOval(
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                color: Colors.grey.shade200,
                child: Icon(
                  _getSensorIcon(name),
                  color: GlobalColors.sideBar,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Sensor Value
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            // Sensor Name
            Text(
              name,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            // Sensor Unit
            Text(
              unit,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to get an icon based on the sensor name
  IconData _getSensorIcon(String name) {
    switch (name.toLowerCase()) {
      case "temperature":
        return Icons.thermostat;
      case "speed":
        return Icons.speed;
      case "humidity":
        return Icons.water_drop;
      case "pressure":
        return Icons.monitor_weight_outlined;
      case "tension":
        return Icons.bolt;
      case "courant":
        return Icons.electric_bolt;
      case "couple":
        return Icons.settings_input_component;
      case "vibration":
        return Icons.vibration;
      case "efficiency":
        return Icons.power_input;
      case "push":
        return Icons.publish_sharp;
      default:
        return Icons.speed;
    }
  }

  // Helper method to format sensor values dynamically
  String _formatSensorValue(String name, double value) {
    switch (name.toLowerCase()) {
      case "temperature":
        return "${value.toStringAsFixed(1)}°C";
      case "pressure":
        return "${(value / 10).toStringAsFixed(2)} ";
      case "tension":
        return "${(value ).toStringAsFixed(2)} ";
      case "courant":
        return "${(value / 50).toStringAsFixed(2)} ";
      case "couple":
        return "${(value / 100).toStringAsFixed(2)} ";
      case "vibration":
        return "${(value / 200).toStringAsFixed(2)}";
      default:
        return "${value.toStringAsFixed(2)}";
    }
  }
}
