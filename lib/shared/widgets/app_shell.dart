import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../features/cart/providers/cart_provider.dart';

/// Persistent shell that wraps all 5 main tab pages.
/// Bottom nav bar stays alive as the user switches tabs.
class AppShell extends ConsumerWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  static const _tabs = [
    _Tab('Home', Icons.home_outlined, Icons.home, '/'),
    _Tab('Shop', Icons.storefront_outlined, Icons.storefront, '/shop'),
    _Tab('Cart', Icons.shopping_bag_outlined, Icons.shopping_bag, '/cart'),
    _Tab('Blog', Icons.article_outlined, Icons.article, '/blog'),
    _Tab('Profile', Icons.person_outline, Icons.person, '/profile'),
  ];

  int _indexFromLocation(String location) {
    // Match by prefix so /shop/product-slug keeps Shop active
    for (int i = _tabs.length - 1; i >= 0; i--) {
      if (_tabs[i].route == '/'
          ? location == '/'
          : location.startsWith(_tabs[i].route)) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartItemCountProvider);
    final location = GoRouterState.of(context).uri.path;
    final currentIdx = _indexFromLocation(location);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.background,
        // ── Top bar: logo only ──────────────────────────────────────────────
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          scrolledUnderElevation: 1,
          shadowColor: AppColors.divider,
          centerTitle: false,
          title: GestureDetector(
            onTap: () => context.go('/'),
            child: Text(
              'Anmol Bakery',
              style: AppTypography.headlineLarge.copyWith(
                color: AppColors.accent,
                letterSpacing: 1.2,
              ),
            ),
          ),
          actions: [
            // Cart badge shortcut in top bar
            Stack(
              children: [
                IconButton(
                  onPressed: () => context.go('/cart'),
                  icon: const Icon(Icons.shopping_bag_outlined),
                  color: AppColors.textDark,
                  iconSize: 26,
                ),
                if (cartCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: IgnorePointer(
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$cartCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),
        // ── Page content ────────────────────────────────────────────────────
        body: child,
        // ── Bottom navigation bar ───────────────────────────────────────────
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 72,
              child: Row(
                children: List.generate(_tabs.length, (i) {
                  final tab = _tabs[i];
                  final isActive = i == currentIdx;
                  final isCart = tab.route == '/cart';

                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => context.go(tab.route),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Cart gets a badge overlay
                            isCart
                                ? Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Icon(
                                        isActive ? tab.activeIcon : tab.icon,
                                        color: isActive
                                            ? AppColors.primary
                                            : AppColors.textLight,
                                        size: 24,
                                      ),
                                      if (cartCount > 0)
                                        Positioned(
                                          right: -6,
                                          top: -4,
                                          child: Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: const BoxDecoration(
                                              color: AppColors.primary,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              '$cartCount',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  )
                                : Icon(
                                    isActive ? tab.activeIcon : tab.icon,
                                    color: isActive
                                        ? AppColors.primary
                                        : AppColors.textLight,
                                    size: 24,
                                  ),
                            const SizedBox(height: 4),
                            Text(
                              tab.label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isActive
                                    ? AppColors.primary
                                    : AppColors.textLight,
                              ),
                            ),
                            // Active indicator dot
                            const SizedBox(height: 2),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: isActive ? 4 : 0,
                              height: isActive ? 4 : 0,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tab {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;
  const _Tab(this.label, this.icon, this.activeIcon, this.route);
}
