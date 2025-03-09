import 'package:flutter/material.dart';
import 'package:flareline_uikit/components/charts/line_chart.dart';
import 'package:flareline_uikit/components/card/common_card.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../_services/websocket_service.dart';

class SensorDataWidget extends StatefulWidget {
  const SensorDataWidget({super.key});

  @override
  _SensorDataWidgetState createState() => _SensorDataWidgetState();
}

class _SensorDataWidgetState extends State<SensorDataWidget> {
  late final WebSocketService _webSocketService;
  final List<Map<String, dynamic>> _tensionData = [];
  static const int _maxDataPoints = 60;
  DateTime? _lastUpdate;

  @override
  void initState() {
    super.initState();
    _webSocketService = WebSocketService();
    _setupWebSocketListener();
  }

  void _setupWebSocketListener() {
    _webSocketService.stream.listen((data) {
      print('Received data: $data'); // Debugging: Check received data

      if (data.containsKey('value')) {
        final value = data['value'];
        if (value is num) {
          // Only accept values between 10 and 30
          if (value >= 30 && value <= 40) {
            _updateChartData(value.toDouble());
          } else {
            print('Value out of range: $value');
          }
        }
      }
    }, onError: (error) {
      print('WebSocket error: $error');
    });
  }
  void _updateChartData(double tension) {
    final now = DateTime.now();
    setState(() {
      _tensionData.add({
        'x': '${now.hour.toString().padLeft(2, '0')}:'
            '${now.minute.toString().padLeft(2, '0')}:'
            '${now.second.toString().padLeft(2, '0')}',
        'y': tension,
      });

      if (_tensionData.length > _maxDataPoints) {
        _tensionData.removeAt(0);
      }

      _lastUpdate = now;
    });
  }

  @override
  void dispose() {
    _webSocketService.dispose();
    super.dispose();
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
              title: 'Tension (V)',
              dropdownItems: const [],
              datas: [
                {
                  'name': 'Tension',
                  'color': const Color(0xFF109FDB),
                  'data': _tensionData.isNotEmpty
                      ? _tensionData
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
    return [
      {
        'x': '${now.toString().substring(11, 19)}',
        'y': 0,
      }
    ];
  }
}
