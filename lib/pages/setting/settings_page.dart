import 'package:flareline/pages/setting/personal_avatar_widget.dart';
import 'package:flareline/pages/setting/personal_info_widget.dart';
import 'package:flareline/pages/setting/ConnectionPanel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

import 'package:flareline/pages/layout.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flareline/flutter_gen/app_localizations.dart';

class SettingsPage extends LayoutWidget {
  SettingsPage({super.key});

  @override
  String breakTabTitle(BuildContext context) {
    return AppLocalizations.of(context)!.settings;
  }

  @override
  Widget contentDesktopWidget(BuildContext context) {
    return ScreenTypeLayout.builder(
      desktop: _desktopWidget,
      mobile: _mobileWidget,
      tablet: _mobileWidget,
    );
  }

  Widget _desktopWidget(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: _leftWidget(context)),
        const SizedBox(width: 16),
        Expanded(flex: 2, child: _rightWidget(context)),
      ],
    );
  }

  Widget _mobileWidget(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _leftWidget(context),
          const SizedBox(height: 16),
          _rightWidget(context),
        ],
      ),
    );
  }

  Widget _leftWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ConnectionPanel(),
        const SizedBox(height: 20),
        _tipsSection(context),
        const SizedBox(height: 20),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _rightWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PersonalAvatarWidget(),
        const SizedBox(height: 20),

        const SizedBox(height: 20),

      ],
    );
  }


  Widget _tipsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, size: 24, color: Theme.of(context).colorScheme.onTertiaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  " Quick Tips",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                      "🔹 Enable two-factor authentication for extra security.\n"
                      "🔹 Use the 'Connection' panel to check device status.\n"
                      "🔹 Customize your avatar for a better profile appearance.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
