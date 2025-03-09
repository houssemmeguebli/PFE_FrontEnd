import 'package:flutter/material.dart';
import 'package:flareline/pages/dashboard/grid_card.dart';
import 'package:flareline/pages/layout.dart';
import 'SensorDataWidget.dart';

class Dashboard extends LayoutWidget {
  const Dashboard({super.key});

  @override
  String breakTabTitle(BuildContext context) {
    return 'Dashboard';
  }

  @override
  Widget contentDesktopWidget(BuildContext context) {
    // List of sensors with their names and units
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
            // Grid Cards (5 per row)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 16, // Spacing between cards horizontally
                mainAxisSpacing: 16, // Spacing between cards vertically
                childAspectRatio: 1.5, // Adjust the aspect ratio as needed
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

            // Charts Section (3 charts per row)
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
  Widget contentMobileWidget(BuildContext context) {
    // List of sensors for mobile (fewer cards)
    final List<Map<String, String>> sensors = [
      {"name": "Temperature", "unit": "°C"},
      {"name": "Humidity", "unit": "%"},
      {"name": "Pressure", "unit": "hPa"},
      {"name": "Tension", "unit": "V"},
      {"name": "Current", "unit": "A"},
      {"name": "Torque", "unit": "N"},
      {"name": "Vibration", "unit": ""},
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Grid Cards (1 per row on mobile)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, // 1 card per row on mobile
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

            // Charts (1 per row on mobile)
            Column(
              children: const [
                SensorDataWidget(),
                SizedBox(height: 16),
                SensorDataWidget(),
                SizedBox(height: 16),
                SensorDataWidget(),
                SizedBox(height: 16),
                SensorDataWidget(),
                SizedBox(height: 16),
                SensorDataWidget(),
                SizedBox(height: 16),
                SensorDataWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
