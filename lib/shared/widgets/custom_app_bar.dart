import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../features/cart/providers/cart_provider.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartItemCountProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppColors.isDark(context)
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: AppBar(
        toolbarHeight: 60,
        backgroundColor: AppColors.bg(context),
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: AppColors.dividerColor(context),
        centerTitle: false,
        automaticallyImplyLeading: true,
        leading: context.canPop()
            ? IconButton(
                icon: Icon(Icons.arrow_back,
                    color: AppColors.textPrimary(context)),
                onPressed: () => context.pop(),
              )
            : null,
        title: GestureDetector(
          onTap: () => context.go('/'),
          child: Text(
            'Anmol Bakery',
            style: AppTypography.headlineLarge.copyWith(
              color: AppColors.accentColor(context),
              letterSpacing: 1.2,
            ),
          ),
        ),
        actions: [
          // Cart icon with badge
          Stack(
            children: [
              IconButton(
                onPressed: () => context.push('/cart'),
                icon: const Icon(Icons.shopping_bag_outlined),
                color: AppColors.textPrimary(context),
                iconSize: 26,
              ),
              if (cartCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
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
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
