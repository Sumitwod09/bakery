import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../shared/widgets/section_title.dart';
import '../../../shared/widgets/responsive_container.dart';

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  static const _testimonials = [
    _Testimonial(
      name: 'Priya Sharma',
      quote:
          'The croissants are absolutely divine — flaky, buttery, and made with so much love. I order every Saturday!',
      role: 'Regular Customer',
    ),
    _Testimonial(
      name: 'Rahul Mehta',
      quote:
          'Got a custom wedding cake here and it was the star of the event. Stunning design and incredible taste!',
      role: 'Wedding Client',
    ),
    _Testimonial(
      name: 'Sana Kapoor',
      quote:
          'Best sourdough in the city, hands down. The delivery was on time and the bread was still warm. 10/10!',
      role: 'Food Blogger',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      child: ResponsiveContainer(
        child: Column(
          children: [
            const SectionTitle(
              title: 'What Our Customers Say',
              subtitle:
                  'Real stories from real customers who love what we bake.',
            ),
            const SizedBox(height: 48),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: _testimonials
                  .map((t) => _TestimonialCard(testimonial: t))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final _Testimonial testimonial;
  const _TestimonialCard({required this.testimonial});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"',
            style: TextStyle(
              fontSize: 48,
              color: AppColors.primary,
              height: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(testimonial.quote, style: AppTypography.bodyLarge),
          const SizedBox(height: 20),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryLight,
                radius: 20,
                child: Text(
                  testimonial.name[0],
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(testimonial.name, style: AppTypography.labelLarge),
                  Text(testimonial.role, style: AppTypography.caption),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05);
  }
}

class _Testimonial {
  final String name;
  final String quote;
  final String role;
  const _Testimonial({
    required this.name,
    required this.quote,
    required this.role,
  });
}
