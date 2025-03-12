import 'package:flutter/material.dart';
import 'package:flareline/pages/layout.dart'; // Assuming this exists

class SafetyCutoffSettings extends LayoutWidget {
  const SafetyCutoffSettings({super.key});

  @override
  String breakTabTitle(BuildContext context) {
    return 'Safety Cutoff Settings';
  }

  @override
  Widget contentDesktopWidget(BuildContext context) {
    return _SafetyCutoffContent();
  }

  @override
  Widget contentMobileWidget(BuildContext context) {
    return _SafetyCutoffContent();
  }
}

class _SafetyCutoffContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// **Enhanced Header Section**
            _buildHeaderSection(context),
            const SizedBox(height: 32),

            /// **Grid-based Safety Cutoff Layout with Save Button**
            _buildSafetyCutoffGrid(context),
          ],
        ),
      ),
    );
  }

  /// **Enhanced Header Section with Gradient and Shadow**
  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.lightBlue.shade700, Colors.lightBlue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Safety Cutoff Settings",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "ESC Cutoff Value: 1100 (µs)",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "The system will automatically cut off the throttle when any of these limits are exceeded.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white60,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.white.withOpacity(0.3)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// **Grid-based Safety Cutoff Layout with Integrated Save Button**
  Widget _buildSafetyCutoffGrid(BuildContext context) {
    final List<Map<String, String>> safetyData = [
      {"parameter": "Voltage (V)", "min": "13.2", "max": "18", "system": "0 / 50"},
      {"parameter": "Continuous Current (A)", "min": "-0.1", "max": "15", "system": "-55 / 55"},
      {"parameter": "Burst Current (A)", "min": "-0.1", "max": "25", "system": "-60 / 60"},
      {"parameter": "Power (W)", "min": "0", "max": "600", "system": "0 / 2750"},
      {"parameter": "Thrust (gf)", "min": "-1000", "max": "2040", "system": "-5000 / 5000"},
      {"parameter": "Torque (N·m)", "min": "-0.5", "max": "0.5", "system": "-2.0 / 2.0"},
      {"parameter": "Motor Speed (RPM)", "min": "0", "max": "15000", "system": "0 / 100000"},
      {"parameter": "Vibration (g)", "min": "0", "max": "3", "system": "0 / 8"},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Safety Cutoff Limits",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey.shade800,
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 350, // Max width of each card
              childAspectRatio: 1.2, // Adjust height relative to width
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: safetyData.length,
            itemBuilder: (context, index) {
              final data = safetyData[index];
              return _buildSafetyCard(data);
            },
          ),
          const SizedBox(height: 24),
          // Integrated Save Settings Button
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                // Handle Save Settings
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.lightBlue.shade600, Colors.lightBlue.shade400],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Text(
                  "Save Settings",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// **Custom Grid Card**
  Widget _buildSafetyCard(Map<String, String> data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Parameter Title
          Text(
            data['parameter']!,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          // Min and Max Fields
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildGridField("Min", data['min']!),
              _buildGridField("Max", data['max']!),
            ],
          ),
          const SizedBox(height: 12),
          // System Range
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "System:",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey.shade600,
                ),
              ),
              Text(
                data['system']!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blueGrey.shade400,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// **Compact Grid Field**
  Widget _buildGridField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 80,
          child: TextFormField(
            initialValue: value,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              hoverColor: Colors.blueGrey.shade50,
            ),
            style: TextStyle(
              fontSize: 14,
              color: Colors.blueGrey.shade700,
            ),
          ),
        ),
      ],
    );
  }
}