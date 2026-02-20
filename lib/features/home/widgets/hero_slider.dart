import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../shared/widgets/primary_button.dart';

class HeroSlider extends StatefulWidget {
  const HeroSlider({super.key});

  @override
  State<HeroSlider> createState() => _HeroSliderState();
}

class _HeroSliderState extends State<HeroSlider> {
  int _current = 0;

  final List<_HeroSlide> _slides = const [
    _HeroSlide(
      tag: 'FRESHLY BAKED DAILY',
      title: 'Taste the Art\nof Baking',
      subtitle:
          'Handcrafted cakes, pastries, and breads baked with love every morning.',
      bgColor: Color(0xFF2C1810),
      accentColor: AppColors.primaryLight,
    ),
    _HeroSlide(
      tag: 'SEASONAL SPECIALS',
      title: 'Indulge in Our\nNew Season Menu',
      subtitle:
          'Discover flavours that celebrate the best of every season, beautifully made.',
      bgColor: Color(0xFF4A2010),
      accentColor: AppColors.primaryLight,
    ),
    _HeroSlide(
      tag: 'CUSTOM ORDERS',
      title: 'Your Dream Cake,\nOur Craft',
      subtitle:
          'Custom orders for weddings, birthdays, and celebrations — made just for you.',
      bgColor: Color(0xFF1A0F08),
      accentColor: AppColors.primaryLight,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_current];
    final isMobile = MediaQuery.of(context).size.width < 800;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      color: slide.bgColor,
      width: double.infinity,
      height: isMobile ? 480 : 600,
      child: Stack(
        children: [
          // Subtle decorative circles
          Positioned(
            right: -80,
            top: -80,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.03),
              ),
            ),
          ),
          Positioned(
            left: -60,
            bottom: -60,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.08),
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24 : 80,
              vertical: 48,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                      slide.tag,
                      style: AppTypography.caption.copyWith(
                        color: slide.accentColor,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                    .animate(key: ValueKey('tag$_current'))
                    .fadeIn(duration: 400.ms),
                const SizedBox(height: 16),
                Text(
                      slide.title,
                      style:
                          (isMobile
                                  ? AppTypography.displaySmall
                                  : AppTypography.displayLarge)
                              .copyWith(color: Colors.white),
                    )
                    .animate(key: ValueKey('title$_current'))
                    .fadeIn(delay: 100.ms, duration: 500.ms)
                    .slideY(begin: 0.1),
                const SizedBox(height: 20),
                SizedBox(
                      width: isMobile ? double.infinity : 480,
                      child: Text(
                        slide.subtitle,
                        style: AppTypography.bodyLarge.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    )
                    .animate(key: ValueKey('sub$_current'))
                    .fadeIn(delay: 200.ms, duration: 500.ms),
                const SizedBox(height: 36),
                Row(
                      children: [
                        PrimaryButton(
                          label: 'Shop Now',
                          onPressed: () => context.go('/shop'),
                        ),
                        const SizedBox(width: 16),
                        TextButton(
                          onPressed: () => context.go('/contact'),
                          child: Text(
                            'Custom Orders →',
                            style: AppTypography.labelLarge.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    )
                    .animate(key: ValueKey('btn$_current'))
                    .fadeIn(delay: 300.ms, duration: 400.ms),
              ],
            ),
          ),
          // Slide dots
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (i) => GestureDetector(
                  onTap: () => setState(() => _current = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _current == i ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _current == i ? AppColors.primary : Colors.white30,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSlide {
  final String tag;
  final String title;
  final String subtitle;
  final Color bgColor;
  final Color accentColor;

  const _HeroSlide({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.bgColor,
    required this.accentColor,
  });
}
