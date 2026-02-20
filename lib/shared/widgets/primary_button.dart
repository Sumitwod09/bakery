import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

/// Premium PrimaryButton with gold gradient option
class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final bool isGold; // Uses the metallic gold gradient
  final IconData? icon;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.isGold = false,
    this.icon,
    this.width,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    final child = widget.isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: isDark ? AppColors.backgroundDark : Colors.white,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(widget.label.toUpperCase(), style: AppTypography.buttonText),
            ],
          );

    if (widget.isOutlined) {
      return SizedBox(
        width: widget.width,
        child: OutlinedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          child: child,
        ),
      );
    }

    // Gold gradient CTA button
    if (widget.isGold) {
      return MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.isLoading ? null : widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: widget.width,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _hovered
                    ? [
                        const Color(0xFFB88A2F),
                        const Color(0xFFE6B76E),
                        const Color(0xFFC89B3C),
                      ]
                    : [
                        const Color(0xFFC89B3C),
                        const Color(0xFFE6B76E),
                        const Color(0xFFB88A2F),
                      ],
              ),
              borderRadius: BorderRadius.circular(4),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: const Color(0xFFC89B3C).withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : [],
            ),
            child: DefaultTextStyle(
              style: AppTypography.buttonText
                  .copyWith(color: const Color(0xFF2E1A1A)),
              child: child,
            ),
          ),
        ),
      ).animate().fadeIn(duration: 200.ms);
    }

    // Standard primary button
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: SizedBox(
        width: widget.width,
        child: ElevatedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: _hovered
                ? (isDark
                    ? const Color(0xFFD9A955) // Hover gold dark
                    : const Color(0xFF3A1F1E)) // Hover brown light
                : AppColors.brandPrimary(context),
            foregroundColor: isDark ? AppColors.backgroundDark : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            elevation: 0,
          ),
          child: child,
        ),
      ),
    ).animate().fadeIn(duration: 200.ms);
  }
}
