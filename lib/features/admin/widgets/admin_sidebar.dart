import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';

/// Shared sidebar widget for all admin pages.
class AdminSidebar extends StatelessWidget {
  final String currentRoute;
  const AdminSidebar({super.key, required this.currentRoute});

  Future<void> _signOut(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
    if (context.mounted) context.go('/admin');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: AppColors.textDark,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 32),
            child: Text('Admin',
                style:
                    AppTypography.headlineMedium.copyWith(color: Colors.white)),
          ),
          _SidebarItem(
              label: 'Dashboard',
              icon: Icons.dashboard_outlined,
              route: '/admin/dashboard',
              current: currentRoute),
          _SidebarItem(
              label: 'Products',
              icon: Icons.inventory_2_outlined,
              route: '/admin/products',
              current: currentRoute),
          _SidebarItem(
              label: 'Orders',
              icon: Icons.shopping_bag_outlined,
              route: '/admin/orders',
              current: currentRoute),
          const Divider(color: Colors.white24, height: 32),
          _SidebarItem(
              label: 'View Site',
              icon: Icons.open_in_new,
              route: '/',
              current: ''),
          const Spacer(),
          // Sign-out button pinned to the bottom of the sidebar
          ListTile(
            leading:
                const Icon(Icons.logout, color: Colors.redAccent, size: 20),
            title: Text(
              'Sign Out',
              style: AppTypography.labelLarge.copyWith(color: Colors.redAccent),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onTap: () => _signOut(context),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final String route;
  final String current;
  const _SidebarItem(
      {required this.label,
      required this.icon,
      required this.route,
      required this.current});

  @override
  Widget build(BuildContext context) {
    final isActive = current == route;
    return ListTile(
      leading: Icon(icon,
          color: isActive ? AppColors.primary : Colors.white60, size: 20),
      title: Text(label,
          style: AppTypography.labelLarge
              .copyWith(color: isActive ? AppColors.primary : Colors.white70)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: isActive ? Colors.white.withValues(alpha: 0.08) : null,
      onTap: () => context.go(route),
    );
  }
}
