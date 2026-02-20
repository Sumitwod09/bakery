import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/validators.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../shared/widgets/footer.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/responsive_container.dart';
import '../../shared/widgets/section_title.dart';
import '../contact/data/inquiry_repository.dart';

class ContactPage extends ConsumerStatefulWidget {
  const ContactPage({super.key});

  @override
  ConsumerState<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends ConsumerState<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  bool _loading = false;
  bool _submitted = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await InquiryRepository().submitInquiry(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        message: _messageCtrl.text.trim(),
      );
      setState(() => _submitted = true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: AppColors.secondary,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
              child: const SectionTitle(
                title: 'Get in Touch',
                subtitle:
                    'Have a question or a custom order? We\'d love to hear from you.',
              ),
            ),
            const SizedBox(height: 48),
            ResponsiveContainer(
              child: isMobile
                  ? Column(
                      children: [
                        _ContactInfo(),
                        const SizedBox(height: 32),
                        _form(),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _ContactInfo()),
                        const SizedBox(width: 60),
                        Expanded(child: _form()),
                      ],
                    ),
            ),
            const SizedBox(height: 64),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _form() {
    if (_submitted) {
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
              'We\'ll get back to you as soon as possible.',
              style: AppTypography.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Your Name'),
            validator: (v) => Validators.required(v, fieldName: 'Name'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailCtrl,
            decoration: const InputDecoration(labelText: 'Email Address'),
            validator: Validators.email,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _messageCtrl,
            decoration: const InputDecoration(labelText: 'Message'),
            maxLines: 5,
            validator: (v) => Validators.minLength(v, 10, fieldName: 'Message'),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Send Message',
            icon: Icons.send_outlined,
            isLoading: _loading,
            onPressed: _submit,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Visit Us',
          alignment: CrossAxisAlignment.start,
          showDivider: false,
        ),
        const SizedBox(height: 24),
        _InfoRow(
          icon: Icons.location_on_outlined,
          text: '12 Bakery Lane, Mumbai 400001',
        ),
        _InfoRow(icon: Icons.phone_outlined, text: '+91 90236 79874'),
        _InfoRow(icon: Icons.email_outlined, text: 'hello@anmolbakery.in'),
        _InfoRow(icon: Icons.access_time, text: 'Mon–Sat: 9am – 8pm'),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: AppTypography.bodyLarge)),
        ],
      ),
    );
  }
}
