import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/home/home_page.dart';
import '../features/products/shop_page.dart';
import '../features/products/product_detail_page.dart';
import '../features/cart/cart_page.dart';
import '../features/checkout/checkout_page.dart';
import '../features/checkout/order_success_page.dart';
import '../features/blog/blog_list_page.dart';
import '../features/blog/blog_detail_page.dart';
import '../features/contact/contact_page.dart';
import '../features/profile/profile_page.dart';
import '../features/admin/admin_login_page.dart';
import '../features/admin/admin_dashboard_page.dart';
import '../features/admin/admin_products_page.dart';
import '../features/admin/admin_orders_page.dart';
import '../shared/widgets/app_shell.dart';

/// Returns true if the current Supabase session is valid.
bool _isLoggedIn() => Supabase.instance.client.auth.currentSession != null;

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final adminPaths = [
      '/admin/dashboard',
      '/admin/products',
      '/admin/orders',
    ];
    final isAdminProtected =
        adminPaths.any((p) => state.matchedLocation.startsWith(p));
    if (isAdminProtected && !_isLoggedIn()) return '/admin';
    return null;
  },
  routes: [
    // ── Shell: 5 bottom-tab pages ──────────────────────────────────────────
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/', builder: (_, __) => const HomePage()),
        GoRoute(path: '/shop', builder: (_, __) => const ShopPage()),
        GoRoute(path: '/cart', builder: (_, __) => const CartPage()),
        GoRoute(path: '/blog', builder: (_, __) => const BlogListPage()),
        GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
      ],
    ),

    // ── Full-screen routes (no bottom bar) ─────────────────────────────────
    GoRoute(
      path: '/shop/:slug',
      builder: (_, state) =>
          ProductDetailPage(slug: state.pathParameters['slug']!),
    ),
    GoRoute(
      path: '/checkout',
      builder: (_, __) => const CheckoutPage(),
    ),
    GoRoute(
      path: '/checkout/success',
      builder: (_, state) =>
          OrderSuccessPage(orderId: state.uri.queryParameters['orderId']),
    ),
    GoRoute(
      path: '/blog/:slug',
      builder: (_, state) =>
          BlogDetailPage(slug: state.pathParameters['slug']!),
    ),
    GoRoute(path: '/contact', builder: (_, __) => const ContactPage()),

    // ── Admin routes ───────────────────────────────────────────────────────
    GoRoute(path: '/admin', builder: (_, __) => const AdminLoginPage()),
    GoRoute(
      path: '/admin/dashboard',
      builder: (_, __) => const AdminDashboardPage(),
    ),
    GoRoute(
      path: '/admin/products',
      builder: (_, __) => const AdminProductsPage(),
    ),
    GoRoute(
      path: '/admin/orders',
      builder: (_, __) => const AdminOrdersPage(),
    ),
  ],
);
