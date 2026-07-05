import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/auth/auth_service.dart';
import '../../core/auth/user_roles.dart';
import '../../core/theme/clivora_colors.dart';
import '../../core/utils/form_validators.dart';
import '../../data/database/database.dart';
import '../../shared/widgets/clivora_logo.dart';
import '../../shared/widgets/clivora_scaffold.dart';

/// Client account — personal info only (no business/invoice settings).
class ClientAccountScreen extends ConsumerStatefulWidget {
  const ClientAccountScreen({super.key});

  @override
  ConsumerState<ClientAccountScreen> createState() => _ClientAccountScreenState();
}

class _ClientAccountScreenState extends ConsumerState<ClientAccountScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _populate(User? user) {
    if (user == null) return;
    _nameController.text = user.name;
    _emailController.text = user.email;
    _initialized = true;
  }

  Future<void> _pickPhoto(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source, maxWidth: 1024, imageQuality: 85);
    if (!mounted || file == null) return;
    final error = await ref.read(authStateProvider.notifier).updateProfilePhoto(file.path);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error ?? 'Profile photo updated')),
    );
  }

  Future<void> _save() async {
    final nameErr = FormValidators.requiredField(_nameController.text, field: 'Name');
    if (nameErr != null) {
      showFormError(context, nameErr);
      return;
    }
    final emailErr = FormValidators.email(_emailController.text, required: true);
    if (emailErr != null) {
      showFormError(context, emailErr);
      return;
    }
    final error = await ref.read(authStateProvider.notifier).updateProfile(
          name: _nameController.text,
          email: _emailController.text,
        );
    if (!mounted) return;
    if (error != null) {
      showFormError(context, error);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account updated')));
  }

  Future<void> _signOut() async {
    await ref.read(authStateProvider.notifier).signOut();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).valueOrNull;
    if (!_initialized && user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _populate(user));
      });
    }

    return ClivoraScaffold(
      title: 'My Account',
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: ClivoraColors.clientGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                ProfileAvatar(photoPath: user?.profilePhotoPath, name: user?.name ?? 'C', radius: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'CLIENT ACCOUNT',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user?.name ?? 'Client',
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        user?.email ?? '',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Stack(
              children: [
                ProfileAvatar(photoPath: user?.profilePhotoPath, name: _nameController.text, radius: 48),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Material(
                    color: ClivoraColors.clientAccent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () => _pickPhoto(ImageSource.gallery),
                      customBorder: const CircleBorder(),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'FULL NAME', prefixIcon: Icon(Icons.person_outline)),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'EMAIL', prefixIcon: Icon(Icons.email_outlined)),
          ),
          const SizedBox(height: 8),
          Text(
            'Your freelancer shares projects with this email address.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ClivoraColors.textSecondary),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(backgroundColor: ClivoraColors.clientAccent),
            child: const Text('Save Changes'),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: _signOut,
            child: const Text('Sign Out', style: TextStyle(color: ClivoraColors.errorRed)),
          ),
          const SizedBox(height: 24),
          const Center(child: ClivoraLogo(size: 28, borderRadius: 8)),
        ],
      ),
    );
  }
}
