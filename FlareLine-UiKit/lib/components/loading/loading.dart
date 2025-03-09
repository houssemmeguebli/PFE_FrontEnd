library flareline_uikit;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // For professional animations

class LoadingWidget extends StatelessWidget {
  final double size; // Custom size for the loading indicator
  final Color? color; // Custom color for the loading indicator
  final double strokeWidth; // Stroke width for CircularProgressIndicator
  final String? loadingText; // Optional text to display below the indicator
  final bool useProfessionalAnimation; // Use a professional animation

  const LoadingWidget({
    super.key,
    this.size = 30.0,
    this.color,
    this.strokeWidth = 4.0,
    this.loadingText,
    this.useProfessionalAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color indicatorColor = color ?? theme.primaryColor;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (useProfessionalAnimation)
            SpinKitFadingCircle(
              color: indicatorColor,
              size: size,
            )
          else
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
                strokeWidth: strokeWidth,
              ),
            ),
          if (loadingText != null) ...[
            const SizedBox(height: 16), // Spacing between indicator and text
            Text(
              loadingText!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}