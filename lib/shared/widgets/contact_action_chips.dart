import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/clivora_colors.dart';

/// One-tap call, email, and WhatsApp actions for a customer row.
class ContactActionChips extends StatelessWidget {
  const ContactActionChips({
    super.key,
    required this.phone,
    required this.email,
    this.whatsapp,
  });

  final String phone;
  final String email;
  final String? whatsapp;

  Future<void> _open(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];
    if (phone.isNotEmpty) {
      chips.add(ActionChip(
        avatar: const Icon(Icons.phone_outlined, size: 16),
        label: const Text('Call'),
        onPressed: () => _open(Uri(scheme: 'tel', path: phone)),
      ));
    }
    if (email.isNotEmpty) {
      chips.add(ActionChip(
        avatar: const Icon(Icons.email_outlined, size: 16),
        label: const Text('Email'),
        onPressed: () => _open(Uri(scheme: 'mailto', path: email)),
      ));
    }
    final wa = (whatsapp ?? phone).replaceAll(RegExp(r'[^\d+]'), '');
    if (wa.isNotEmpty) {
      chips.add(ActionChip(
        avatar: const Icon(Icons.chat_outlined, size: 16, color: ClivoraColors.successGreen),
        label: const Text('WhatsApp'),
        onPressed: () => _open(Uri.parse('https://wa.me/$wa')),
      ));
    }
    if (chips.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(spacing: 8, runSpacing: 4, children: chips),
    );
  }
}
