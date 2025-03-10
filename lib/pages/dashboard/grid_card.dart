import 'package:flareline/core/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flareline_uikit/components/card/common_card.dart';
import 'package:responsive_builder/responsive_builder.dart';

class GridCard extends StatelessWidget {
  final String name;
  final String unit;
  final String value;

  const GridCard({
    super.key,
    required this.name,
    required this.unit,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      desktop: contentDesktopWidget,
      mobile: contentMobileWidget,
      tablet: contentTabletWidget,
    );
  }

  // Content for Desktop
  Widget contentDesktopWidget(BuildContext context) {
    return _itemCardWidget(context, name, value, unit);
  }

  // Content for Mobile
  Widget contentMobileWidget(BuildContext context) {
    return _itemCardWidget(context, name, value, unit);
  }

  // Content for Tablet
  Widget contentTabletWidget(BuildContext context) {
    return _itemCardWidget(context, name, value, unit);
  }

  // Common method to create the card
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
      case "current":
        return Icons.electric_bolt;
      case "torque":
        return Icons.settings_input_component;
      case "vibration":
        return Icons.vibration;
      case "efficiency":
        return Icons.power_input;
      case "push":
        return Icons.publish_sharp;
      default:
        return Icons.device_unknown; // Default icon for unknown sensors
    }
  }
}