import 'dart:convert';
import 'package:flareline/_services/websocket_service.dart';
import 'package:flareline_uikit/components/sidebar/side_menu.dart';
import 'package:flareline_uikit/core/theme/flareline_colors.dart';
import 'package:flutter/material.dart';

class SideBarWidget extends StatefulWidget {
  final double? width;
  final String? appName;
  final String? sideBarAsset;
  final Widget? logoWidget;
  final bool? isDark;
  final Color? darkBg;
  final Color? lightBg;
  final Widget? footerWidget;
  final double? logoFontSize;

  SideBarWidget({
    super.key,
    this.darkBg,
    this.lightBg,
    this.width,
    this.appName,
    this.sideBarAsset,
    this.logoWidget,
    this.footerWidget,
    this.logoFontSize = 30,
    this.isDark,
  });

  @override
  _SideBarWidgetState createState() => _SideBarWidgetState();
}

class _SideBarWidgetState extends State<SideBarWidget> {
  final ValueNotifier<String> expandedMenuName = ValueNotifier('');
  final WebSocketService _webSocketService = WebSocketService();

  // Sensor values initialized as null-safe empty values
  Map<String, String> sensorValues = {
    "Temperature": "0",
    "Pressure": "0",
    "Tension": "0",
    "Courant": "0",
    "Couple": "0",
    "Vibration": "0",
  };

  @override
  void initState() {
    super.initState();
    _webSocketService.stream.listen((data) {
      if (data.containsKey('event') && data['event'] == 'randomValue') {
        setState(() {
          sensorValues["Temperature"] = "${data['value']}°C";
          sensorValues["Pressure"] = "${(data['value'] / 10).toStringAsFixed(2)} hPa";
          sensorValues["Tension"] = "${(data['value'] ).toStringAsFixed(2)} V";
          sensorValues["Courant"] = "${(data['value'] / 50).toStringAsFixed(2)} A";
          sensorValues["Couple"] = "${(data['value'] / 100).toStringAsFixed(2)} N";
          sensorValues["Vibration"] = "${(data['value'] / 200).toStringAsFixed(2)} ";
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
    bool isDarkTheme = widget.isDark ?? false;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      color: (isDarkTheme ? widget.darkBg : Colors.white),
      width: widget.width ?? 280,
      child: Column(
        children: [
          _logoWidget(context, isDarkTheme),
          const SizedBox(height: 30),
          Expanded(
            child: Column(
              children: [
                Expanded(child: _sideListWidget(context, isDarkTheme)),
                _buildSensorList(context, isDarkTheme),
              ],
            ),
          ),
          if (widget.footerWidget != null) widget.footerWidget!,
        ],
      ),
    );
  }

  // Logo Widget
  Widget _logoWidget(BuildContext context, bool isDark) {
    return Row(
      children: [
        const SizedBox(width: 8),
        if (widget.logoWidget != null) widget.logoWidget!,
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            widget.appName ?? '',
            style: TextStyle(
              color: isDark ? Colors.white : FlarelineColors.darkBlackText,
              fontSize: widget.logoFontSize,
            ),
          ),
        ),
      ],
    );
  }

  // Side Menu List
  Widget _sideListWidget(BuildContext context, bool isDark) {
    if (widget.sideBarAsset == null) return const SizedBox.shrink();

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString(widget.sideBarAsset!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
            return const SizedBox.shrink();
          }

          List listMenu = json.decode(snapshot.data.toString());
          return ListView.separated(
            padding: const EdgeInsets.only(left: 20, right: 10),
            itemBuilder: (ctx, index) => itemBuilder(ctx, index, listMenu, isDark),
            separatorBuilder: separatorBuilder,
            itemCount: listMenu.length,
          );
        },
      ),
    );
  }

  // Menu Item Builder
  Widget itemBuilder(BuildContext context, int index, List listMenu, bool isDark) {
    var groupElement = listMenu.elementAt(index);
    List menuList = groupElement['menuList'];
    String? groupName = groupElement['groupName']; // Nullable check

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (groupName != null && groupName.isNotEmpty)
          Text(
            groupName,
            style: TextStyle(
              fontSize: 20,
              color: isDark ? Colors.white60 : FlarelineColors.darkBlackText,
            ),
          ),
        if (groupName != null && groupName.isNotEmpty) const SizedBox(height: 10),
        Column(
          children: menuList
              .map((e) => SideMenuWidget(
            e: e,
            isDark: isDark,
            expandedMenuName: expandedMenuName,
          ))
              .toList(),
        ),
        const SizedBox(height: 10),
        if (index < listMenu.length - 1) const Divider(),
        const SizedBox(height: 10),
      ],
    );
  }

  // Separator Builder
  Widget separatorBuilder(BuildContext context, int index) {
    return const Divider(height: 10, color: Colors.transparent);
  }

  // Build Sensor List with WebSocket Dynamic Data
  Widget _buildSensorList(BuildContext context, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sensorValues.entries.map((entry) => _buildSensorItem(entry.key, entry.value, isDark)).toList(),
      ),
    );
  }

  // Build Single Sensor Item
  Widget _buildSensorItem(String name, String value, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.shade300,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : FlarelineColors.darkBlackText,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : FlarelineColors.darkBlackText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
