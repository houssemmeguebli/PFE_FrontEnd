import 'package:flutter/material.dart';
import 'package:flareline_uikit/components/charts/line_chart.dart';
import 'package:flareline_uikit/components/card/common_card.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SensorDataWidget extends StatefulWidget {
  final String sensorType;
  final double sensorValue;

  const SensorDataWidget({
    super.key,
    required this.sensorType,
    required this.sensorValue,
  });

  @override
  _SensorDataWidgetState createState() => _SensorDataWidgetState();
}

class _SensorDataWidgetState extends State<SensorDataWidget> {
  final List<Map<String, dynamic>> _sensorData = [];
  static const int _maxDataPoints = 60;
  DateTime? _lastUpdate;

  @override
  void initState() {
    super.initState();
    _updateChartData(widget.sensorValue); // Initialize with the initial value
  }

  @override
  void didUpdateWidget(covariant SensorDataWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sensorValue != widget.sensorValue) {
      _updateChartData(widget.sensorValue); // Update chart when value changes
    }
  }

  void _updateChartData(double value) {
    final now = DateTime.now();
    setState(() {
      _sensorData.add({
        'x':'${now.hour.toString().padLeft(2, '0')}:'
            '${now.minute.toString().padLeft(2, '0')}:'
            '${now.second.toString().padLeft(2, '0')}',
        'y': value,
      });

      if (_sensorData.length > _maxDataPoints) {
        _sensorData.removeAt(0); // Limit to max data points
      }

      _lastUpdate = now;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _sensorDataWidget();
  }

  Widget _sensorDataWidget() {
    return ScreenTypeLayout.builder(
      desktop: _buildDesktopLayout,
      mobile: _buildMobileLayout,
      tablet: _buildMobileLayout,
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildChart(),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 360,
          child: _buildChart(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildChart() {
    // Determine unit based on sensor type
    String unit;
    switch (widget.sensorType) {
      case 'Temperature':
        unit = '°C';
        break;
      case 'Pressure':
        unit = 'hPa';
        break;
      case 'Tension':
        unit = 'V';
        break;
      case 'Current':
        unit = 'A';
        break;
      case 'Torque':
        unit = 'N·m';
        break;
      case 'Vibration':
        unit = 'm/s²';
        break;
      default:
        unit = '';
    }

    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _lastUpdate != null
                      ? 'Updated: ${_lastUpdate!.toString().substring(11, 19)}'
                      : 'Awaiting data...',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Expanded(
            child: LineChartWidget(
              title: '${widget.sensorType} ($unit)',
              dropdownItems: const [],
              datas: [
                {
                  'name': widget.sensorType,
                  'color': const Color(0xFF109FDB),
                  'data': _sensorData.isNotEmpty
                      ? _sensorData
                      : _getPlaceholderData(),
                },
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getPlaceholderData() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');
    final timeString = '$hour:$minute:$second';

    debugPrint('Hour: $hour, Minute: $minute, Second: $second');
    debugPrint('Formatted Time: $timeString');

    return [
      {
        'x': timeString,
        'y': 0,
      }
    ];
  }
}