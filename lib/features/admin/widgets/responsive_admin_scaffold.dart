import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import 'admin_sidebar.dart';

/// A scaffold that adapts layout for Admin pages.
/// - Desktop: Shows Sidebar permanently on the left + Body on the right.
/// - Mobile/Tablet: Shows AppBar with Hamburger menu (opens Sidebar in Drawer) + Body.
class ResponsiveAdminScaffold extends StatelessWidget {
  final String currentRoute;
  final String title;
  final Widget body;
  final Widget? floatingActionButton;

  const ResponsiveAdminScaffold({
    super.key,
    required this.currentRoute,
    required this.title,
    required this.body,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    // Check if we are on a smaller screen (Mobile or Tablet)
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(DESKTOP);

    if (isMobile) {
      // ── Mobile/Tablet Layout ──────────────────────────────────────────────
      return Scaffold(
        backgroundColor: const Color(0xFFF7F7F8),
        appBar: AppBar(
          title: Text(title, style: AppTypography.headlineMedium),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: AppColors.textDark),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        drawer: Drawer(
          child: AdminSidebar(currentRoute: currentRoute),
        ),
        body: body,
        floatingActionButton: floatingActionButton,
      );
    } else {
      // ── Desktop Layout ────────────────────────────────────────────────────
      return Scaffold(
        backgroundColor: const Color(0xFFF7F7F8),
        body: Row(
          children: [
            // Permanent Sidebar
            AdminSidebar(currentRoute: currentRoute),
            // Main Content
            Expanded(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: body,
                floatingActionButton: floatingActionButton,
              ),
            ),
          ],
        ),
      );
    }
  }
}
