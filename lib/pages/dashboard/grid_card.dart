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
      desktop: (context) => contentDesktopWidget(context),
      tablet: (context) => contentTabletWidget(context),
      mobile: (context) => contentMobileWidget(context),
    );
  }

  // Content for Desktop
  Widget contentDesktopWidget(BuildContext context) {
    return _itemCardWidget(
      context,
      name: name,
      value: value,
      unit: unit,
      height: 120,
      padding: 16,
      iconSize: 20,
      valueFontSize: 20,
      labelFontSize: 14,
    );
  }

  // Content for Tablet
  Widget contentTabletWidget(BuildContext context) {
    return _itemCardWidget(
      context,
      name: name,
      value: value,
      unit: unit,
      height: 100,
      padding: 12,
      iconSize: 18,
      valueFontSize: 18,
      labelFontSize: 12,
    );
  }

  // Content for Mobile
  Widget contentMobileWidget(BuildContext context) {
    return _itemCardWidget(
      context,
      name: name,
      value: value,
      unit: unit,
      height: 80,
      padding: 10,
      iconSize: 16,
      valueFontSize: 16,
      labelFontSize: 10,
    );
  }

  // Common method to create the card with responsive parameters
  Widget _itemCardWidget(
      BuildContext context, {
        required String name,
        required String value,
        required String unit,
        required double height,
        required double padding,
        required double iconSize,
        required double valueFontSize,
        required double labelFontSize,
      }) {
    return CommonCard(
      height: height,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Sensor Icon
            ClipOval(
              child: Container(
                width: iconSize,
                height: iconSize,
                alignment: Alignment.center,
                color: Colors.grey.shade200,
                child: Icon(
                  _getSensorIcon(name),
                  color: GlobalColors.sideBar,
                  size: iconSize * 0.8, // Slightly smaller than container
                ),
              ),
            ),
            SizedBox(height: padding * 0.75), // Dynamic spacing
            // Sensor Value
            Text(
              value,
              style: TextStyle(
                fontSize: valueFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: padding * 0.5),
            // Sensor Name
            Text(
              name,
              style: TextStyle(
                fontSize: labelFontSize,
                color: Colors.grey.shade700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            // Sensor Unit
            Text(
              unit,
              style: TextStyle(
                fontSize: labelFontSize,
                color: Colors.grey.shade700,
              ),
              overflow: TextOverflow.ellipsis,
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