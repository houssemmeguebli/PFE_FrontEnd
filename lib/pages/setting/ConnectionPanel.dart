import 'package:flutter/material.dart';

class ConnectionPanel extends StatefulWidget {
  const ConnectionPanel({super.key});

  @override
  State<ConnectionPanel> createState() => _ConnectionPanelState();
}

class _ConnectionPanelState extends State<ConnectionPanel> {
  String? selectedPort;
  bool isConnected = false;
  bool isLoading = false;

  final List<String> ports = ['COM1', 'COM2', 'COM3', 'USB0', 'USB1'];

  Future<void> _toggleConnection() async {
    if (selectedPort == null) return;

    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    setState(() {
      isConnected = !isConnected;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surfaceVariant,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Icon
          Row(
            children: [
              Icon(Icons.settings_ethernet_rounded,
                  size: 28, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                'Device Connection',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Port Selection Dropdown
          DropdownButtonFormField<String>(
            value: selectedPort,
            decoration: InputDecoration(
              labelText: 'Select Communication Port',
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceVariant,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            items: ports.map((port) => DropdownMenuItem(
              value: port,
              child: Text(port,
                  style: Theme.of(context).textTheme.bodyMedium),
            )).toList(),
            onChanged: (value) => setState(() => selectedPort = value),
          ),
          const SizedBox(height: 20),

          // Connect Button with Animation
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: selectedPort == null || isLoading ? null : _toggleConnection,
              icon: isLoading
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              )
                  : Icon(
                isConnected ? Icons.link_off_rounded : Icons.link_rounded,
                size: 22,
                color: Colors.white,
              ),
              label: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  isConnected ? 'Disconnect Device' : 'Connect Device',
                  key: ValueKey<bool>(isConnected),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: isConnected
                    ? Colors.redAccent
                    : Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Connection Status Indicator
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isConnected
                    ? [Colors.greenAccent, Colors.green.shade600]
                    : [Colors.redAccent.shade100, Colors.red.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isConnected ? Icons.check_circle_rounded : Icons.error_outline_rounded,
                  size: 22,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Text(
                  isConnected
                      ? 'Connected to $selectedPort'
                      : 'No active connection',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
