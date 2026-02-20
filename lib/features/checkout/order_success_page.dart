import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../shared/widgets/primary_button.dart';

class OrderSuccessPage extends StatelessWidget {
  final String? orderId;
  const OrderSuccessPage({super.key, this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 60,
                ),
              ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
              const SizedBox(height: 32),
              Text(
                'Order Placed!',
                style: AppTypography.displaySmall,
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 12),
              Text(
                'Thank you for your order. We\'ll have it ready and delivered soon!',
                style: AppTypography.bodyLarge,
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 300.ms),
              if (orderId != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Order ID: $orderId',
                  style: AppTypography.caption,
                ).animate().fadeIn(delay: 400.ms),
              ],
              const SizedBox(height: 40),
              PrimaryButton(
                label: 'Continue Shopping',
                onPressed: () => context.go('/shop'),
              ).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/'),
                child: Text(
                  'Back to Home',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}
