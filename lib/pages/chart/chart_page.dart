import 'package:flareline/core/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flareline_uikit/components/card/common_card.dart';
import 'package:flareline_uikit/components/charts/circular_chart.dart';
import 'package:flareline_uikit/components/charts/line_chart.dart';
import 'package:flareline/pages/layout.dart';
import 'package:flareline/flutter_gen/app_localizations.dart';

class ChartPage extends LayoutWidget {
  const ChartPage({super.key});

  @override
  Widget contentDesktopWidget(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 350,
          child: CommonCard(
            child: LineChartWidget(
              title: 'Temperature (°C)',
              dropdownItems: const ['Last Hour', 'Last Day', 'Last Week'],
              datas: const [
                {
                  'name': 'Temperature',
                  'color': Color(0xFFFE8111), // Orange
                  'data': [
                    {'x': '00:00', 'y': 25},
                    {'x': '01:00', 'y': 26},
                    {'x': '02:00', 'y': 27},
                    {'x': '03:00', 'y': 26},
                    {'x': '04:00', 'y': 25},
                    {'x': '05:00', 'y': 24},
                    {'x': '06:00', 'y': 25},
                    {'x': '07:00', 'y': 26},
                    {'x': '08:00', 'y': 27},
                    {'x': '09:00', 'y': 28},
                    {'x': '10:00', 'y': 29},
                    {'x': '11:00', 'y': 30},
                  ],
                },
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 350,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 350,
          child: CommonCard(
            child: CircularhartWidget(
              title: 'Sensor Analytics',
              palette: const [
                GlobalColors.warn,
                GlobalColors.secondary,
                GlobalColors.primary,
              ],
              chartData: const [
                {
                  'x': 'Temperature',
                  'y': 33,
                },
                {
                  'x': 'Humidity',
                  'y': 33,
                },
                {
                  'x': 'Pressure',
                  'y': 34,
                },
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  String breakTabTitle(BuildContext context) {
    return AppLocalizations.of(context)!.chartPageTitle;
  }
}