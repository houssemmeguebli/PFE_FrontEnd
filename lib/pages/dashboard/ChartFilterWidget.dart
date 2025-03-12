import 'package:flutter/material.dart';

class ChartFilterWidget extends StatefulWidget {
  final List<String> chartNames;
  final Function(List<String>) onFilterChanged;

  const ChartFilterWidget({
    super.key,
    required this.chartNames,
    required this.onFilterChanged,
  });

  @override
  _ChartFilterWidgetState createState() => _ChartFilterWidgetState();
}

class _ChartFilterWidgetState extends State<ChartFilterWidget> {
  late Map<String, bool> _filterStates;

  @override
  void initState() {
    super.initState();
    // Initialize all charts as selected by default
    _filterStates = {for (var name in widget.chartNames) name: true};
  }

  void _updateFilter() {
    final selectedCharts = _filterStates.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    widget.onFilterChanged(selectedCharts);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white, // Clean white background
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
        border: Border.all(color: Colors.grey.shade300, width: 1.0), // Subtle border
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Soft shadow
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2), // Slight vertical offset
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Filter Charts:',
            style: TextStyle(
              fontWeight: FontWeight.w600, // Bolder for emphasis
              fontSize: 16,
              color: Colors.black87, // Darker for professionalism
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.chartNames.map((name) => Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: _buildFilterItem(context, name),
                )).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterItem(BuildContext context, String name) {
    return InkWell(
      onTap: () {
        setState(() {
          _filterStates[name] = !_filterStates[name]!;
          _updateFilter();
        });
      },
      hoverColor: Colors.grey.shade100, // Subtle hover effect for desktop
      splashColor: Colors.grey.shade200, // Tap feedback for mobile
      borderRadius: BorderRadius.circular(4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: _filterStates[name],
            onChanged: (bool? value) {
              setState(() {
                _filterStates[name] = value ?? false;
                _updateFilter();
              });
            },
            activeColor: const Color(0xFF109FDB), // Cyan accent for consistency
            checkColor: Colors.white,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4), // Compact spacing
          ),
          const SizedBox(width: 6),
          Text(
            name,
            style: TextStyle(
              fontSize: 14,
              color: _filterStates[name]! ? Colors.black87 : Colors.grey.shade600, // Active vs inactive
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}