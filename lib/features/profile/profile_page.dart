import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../shared/widgets/footer.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/responsive_container.dart';
import '../../shared/widgets/section_title.dart';
import '../../core/utils/validators.dart';
import '../../core/providers/theme_provider.dart';
import '../contact/data/inquiry_repository.dart';

/// Profile tab — combines contact / about info in a mobile-friendly layout.
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  bool _loading = false;
  bool _submitted = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await InquiryRepository().submitInquiry(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        message: _msgCtrl.text.trim(),
      );
      setState(() => _submitted = true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Header banner ────────────────────────────────────────────────
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(gradient: AppColors.heroGradient),
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 48),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, size: 44, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  'Welcome!',
                  style:
                      AppTypography.headlineLarge.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Anmol Bakery — Freshly baked.',
                  style:
                      AppTypography.bodyMedium.copyWith(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 32),

          // ── Quick info cards ─────────────────────────────────────────────
          ResponsiveContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(
                  title: 'Visit Us',
                  alignment: CrossAxisAlignment.start,
                  showDivider: false,
                ),
                const SizedBox(height: 20),
                _InfoCard(
                  icon: Icons.location_on_outlined,
                  title: 'Address',
                  subtitle: '12 Bakery Lane, Mumbai 400001',
                ),
                _InfoCard(
                  icon: Icons.phone_outlined,
                  title: 'Phone',
                  subtitle: '+91 90236 79874',
                ),
                _InfoCard(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  subtitle: 'hello@anmolbakery.in',
                ),
                _InfoCard(
                  icon: Icons.access_time,
                  title: 'Hours',
                  subtitle: 'Mon–Sat: 9am – 8pm',
                ),

                _InfoCard(
                  icon: Icons.access_time,
                  title: 'Hours',
                  subtitle: 'Mon–Sat: 9am – 8pm',
                ),

                const SizedBox(height: 20),
                // Dark Mode Toggle
                Consumer(
                  builder: (context, ref, _) {
                    final themeMode = ref.watch(themeProvider);
                    final isDark = themeMode == ThemeMode.dark;
                    return SwitchListTile(
                      title: Text('Dark Mode', style: AppTypography.bodyLarge),
                      secondary: Icon(
                        isDark ? Icons.dark_mode : Icons.light_mode,
                        color: AppColors.primary,
                      ),
                      value: isDark,
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) {
                        ref.read(themeProvider.notifier).toggleTheme();
                      },
                    );
                  },
                ),

                const SizedBox(height: 32),

                // ── Order shortcut ─────────────────────────────────────────
                PrimaryButton(
                  label: 'Order Now',
                  icon: Icons.shopping_bag_outlined,
                  onPressed: () => context.go('/shop'),
                  width: double.infinity,
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: 'Admin Dashboard',
                  icon: Icons.admin_panel_settings_outlined,
                  onPressed: () => context.go('/admin'),
                  isOutlined: true,
                  width: double.infinity,
                ),

                const SizedBox(height: 40),
                const Divider(),
                const SizedBox(height: 24),

                // ── Contact form ───────────────────────────────────────────
                const SectionTitle(
                  title: 'Send a Message',
                  alignment: CrossAxisAlignment.start,
                  showDivider: false,
                ),
                const SizedBox(height: 20),
                _submitted
                    ? _SuccessCard()
                    : _ContactForm(
                        formKey: _formKey,
                        nameCtrl: _nameCtrl,
                        emailCtrl: _emailCtrl,
                        msgCtrl: _msgCtrl,
                        loading: _loading,
                        onSubmit: _submit,
                      ),
                const SizedBox(height: 72),
              ],
            ),
          ),

          const Footer(),
        ],
      ),
    );
  }
}

// ── Reusable info card ─────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _InfoCard(
      {required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.caption),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTypography.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.05);
  }
}

// ── Success card ───────────────────────────────────────────────────────────
class _SuccessCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: AppColors.success, size: 48),
          const SizedBox(height: 16),
          Text('Message Sent!', style: AppTypography.headlineMedium),
          const SizedBox(height: 8),
          Text(
            "We'll get back to you as soon as possible.",
            style: AppTypography.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().scale(begin: const Offset(0.8, 0.8)).fadeIn();
  }
}

// ── Contact form ───────────────────────────────────────────────────────────
class _ContactForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController msgCtrl;
  final bool loading;
  final VoidCallback onSubmit;
  const _ContactForm({
    required this.formKey,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.msgCtrl,
    required this.loading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nameCtrl,
            decoration: const InputDecoration(labelText: 'Your Name'),
            validator: (v) => Validators.required(v, fieldName: 'Name'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email Address'),
            validator: Validators.email,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: msgCtrl,
            decoration: const InputDecoration(labelText: 'Message'),
            maxLines: 4,
            validator: (v) => Validators.minLength(v, 10, fieldName: 'Message'),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Send Message',
            icon: Icons.send_outlined,
            isLoading: loading,
            onPressed: onSubmit,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
