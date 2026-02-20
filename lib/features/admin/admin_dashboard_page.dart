import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

import '../../core/utils/seed_data.dart';

import 'package:responsive_framework/responsive_framework.dart';
import 'widgets/responsive_admin_scaffold.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(DESKTOP);
    final padding = isMobile ? 16.0 : 40.0;

    return ResponsiveAdminScaffold(
      currentRoute: '/admin/dashboard',
      title: 'Dashboard',
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMobile) ...[
              Text('Dashboard', style: AppTypography.displaySmall),
              const SizedBox(height: 8),
            ],
            Text('Welcome back, Admin.', style: AppTypography.bodyLarge),
            const SizedBox(height: 40),
            const Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                _StatCard(
                    icon: Icons.shopping_bag_outlined,
                    label: 'Total Orders',
                    value: '—',
                    color: AppColors.primary),
                _StatCard(
                    icon: Icons.inventory_2_outlined,
                    label: 'Products',
                    value: '—',
                    color: AppColors.accent),
                _StatCard(
                    icon: Icons.article_outlined,
                    label: 'Blog Posts',
                    value: '—',
                    color: Color(0xFF7B61FF)),
                _StatCard(
                    icon: Icons.mail_outline,
                    label: 'Inquiries',
                    value: '—',
                    color: Color(0xFF00A67E)),
              ],
            ),
            const SizedBox(height: 40),
            Text('Quick Actions', style: AppTypography.headlineMedium),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                ElevatedButton.icon(
                  onPressed: () => context.go('/admin/products'),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Product'),
                ),
                ElevatedButton.icon(
                  onPressed: () => context.go('/admin/orders'),
                  icon: const Icon(Icons.list_alt),
                  label: const Text('View Orders'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      await SeedData.seed();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Products seeded!'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text('Seed Test Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warning,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 16),
          Text(value, style: AppTypography.displaySmall.copyWith(fontSize: 28)),
          const SizedBox(height: 4),
          Text(label, style: AppTypography.bodySmall),
        ],
      ),
    );
  }
}
