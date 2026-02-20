import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          AppColors.isDark(context) ? AppColors.footerDark : AppColors.footerBg,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        children: [
          // Top row
          Wrap(
            alignment: WrapAlignment.spaceAround,
            spacing: 40,
            runSpacing: 32,
            children: [
              _FooterColumn(
                title: 'Anmol Bakery',
                children: [
                  Text(
                    'Handcrafted with love,\nbaked with passion.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              _FooterColumn(
                title: 'Quick Links',
                children: [
                  _FooterLink('Home', '/'),
                  _FooterLink('Shop', '/shop'),
                  _FooterLink('Blog', '/blog'),
                  _FooterLink('Contact', '/contact'),
                ],
              ),
              _FooterColumn(
                title: 'Contact Us',
                children: [
                  Text(
                    '📞 +91 90236 79874',
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '✉️ hello@anmolbakery.in',
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '🕐 Mon–Sat, 9am–8pm',
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Divider(color: Colors.white24, thickness: 1),
          const SizedBox(height: 20),
          Text(
            '© ${DateTime.now().year} Anmol Bakery. All rights reserved.',
            style: AppTypography.caption.copyWith(color: Colors.white54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _FooterColumn({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final String route;

  const _FooterLink(this.label, this.route);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => context.go(route),
        child: Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: Colors.white70,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white30,
          ),
        ),
      ),
    );
  }
}
