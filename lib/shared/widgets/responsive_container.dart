import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets? padding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = 1200,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        child: child,
      ),
    );
  }
}
