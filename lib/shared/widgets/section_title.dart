import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final CrossAxisAlignment alignment;
  final bool showDivider;

  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.alignment = CrossAxisAlignment.center,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        if (showDivider)
          Row(
            mainAxisAlignment: alignment == CrossAxisAlignment.center
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Container(width: 32, height: 2, color: AppColors.primary),
              const SizedBox(width: 10),
              Text(
                '✦',
                style: TextStyle(color: AppColors.primary, fontSize: 10),
              ),
              const SizedBox(width: 10),
              Container(width: 32, height: 2, color: AppColors.primary),
            ],
          ),
        if (showDivider) const SizedBox(height: 12),
        Text(
          title,
          style: AppTypography.displaySmall,
          textAlign: alignment == CrossAxisAlignment.center
              ? TextAlign.center
              : TextAlign.left,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 10),
          Text(
            subtitle!,
            style: AppTypography.bodyLarge,
            textAlign: alignment == CrossAxisAlignment.center
                ? TextAlign.center
                : TextAlign.left,
          ),
        ],
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05);
  }
}
