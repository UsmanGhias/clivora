import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/auth/auth_service.dart';
import '../../core/auth/user_roles.dart';
import '../../core/constants/countries.dart';
import '../../core/theme/clivora_colors.dart';
import '../../core/utils/form_validators.dart';
import '../../data/database/database.dart';
import '../../data/database/user_scoped_queries.dart';
import '../../data/providers/app_providers.dart';
import '../../shared/widgets/clivora_logo.dart';
import '../../shared/widgets/clivora_scaffold.dart';
import '../../shared/widgets/country_picker_field.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalController = TextEditingController();
  String? _country;
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  void _populateFields(User? user, BusinessProfile? profile) {
    if (user == null && profile == null) return;
    _nameController.text = user?.name ?? profile?.ownerName ?? '';
    _emailController.text = user?.email ?? profile?.businessEmail ?? '';
    _phoneController.text = profile?.businessPhone ?? '';
    _addressController.text = profile?.businessAddress ?? '';
    _cityController.text = profile?.businessCity ?? '';
    _postalController.text = profile?.businessPostalCode ?? '';
    _country = (profile?.businessCountry.isNotEmpty == true) ? profile!.businessCountry : kDefaultCountry;
    _initialized = true;
  }

  Future<void> _pickPhoto(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source, maxWidth: 1024, imageQuality: 85);
    if (!mounted || file == null) return;

    final error = await ref.read(authStateProvider.notifier).updateProfilePhoto(file.path);
    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile photo updated')));
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickPhoto(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(ctx);
                _pickPhoto(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final emailErr = FormValidators.email(_emailController.text, required: true);
    if (emailErr != null) {
      showFormError(context, emailErr);
      return;
    }
    final nameErr = FormValidators.requiredField(_nameController.text, field: 'Name');
    if (nameErr != null) {
      showFormError(context, nameErr);
      return;
    }

    final error = await ref.read(authStateProvider.notifier).updateProfile(
          name: _nameController.text,
          email: _emailController.text,
        );
    if (error != null) {
      if (mounted) showFormError(context, error);
      return;
    }

    final userId = ref.read(authStateProvider).valueOrNull?.id;
    if (userId == null) return;

    await ref.read(databaseProvider).saveBusinessProfileForUser(
          userId,
          BusinessProfilesCompanion(
            ownerName: Value(_nameController.text.trim()),
            businessEmail: Value(_emailController.text.trim()),
            businessPhone: Value(_phoneController.text.trim()),
            businessAddress: Value(_addressController.text.trim()),
            businessCity: Value(_cityController.text.trim()),
            businessPostalCode: Value(_postalController.text.trim()),
            businessCountry: Value(_country ?? kDefaultCountry),
          ),
        );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved')));
  }

  Future<void> _signOut() async {
    await ref.read(authStateProvider.notifier).signOut();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final profileAsync = ref.watch(businessProfileProvider);
    final profile = profileAsync.valueOrNull;
    final photoPath = user?.profilePhotoPath ?? profile?.ownerPhotoPath;

    if (!_initialized && (user != null || profile != null)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _populateFields(user, profile));
      });
    }

    return ClivoraScaffold(
      title: isClientUser(user) ? 'My Account' : 'Business Profile',
      showBackButton: true,
      body: profileAsync.isLoading && !_initialized
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: Stack(
                    children: [
                      ProfileAvatar(photoPath: photoPath, name: _nameController.text, radius: 48),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Material(
                          color: ClivoraColors.primaryPurple,
                          shape: const CircleBorder(),
                          child: InkWell(
                            onTap: _showPhotoOptions,
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
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Tap camera to update photo',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 8),
                const Center(child: ClivoraLogo(size: 32, borderRadius: 8)),
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
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'PHONE', prefixIcon: Icon(Icons.phone_outlined)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'BUSINESS ADDRESS', prefixIcon: Icon(Icons.location_on_outlined)),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: TextField(controller: _cityController, decoration: const InputDecoration(labelText: 'CITY'))),
                    const SizedBox(width: 12),
                    Expanded(child: TextField(controller: _postalController, decoration: const InputDecoration(labelText: 'POSTAL'))),
                  ],
                ),
                const SizedBox(height: 16),
                CountryPickerField(
                  value: _country,
                  onChanged: (v) => setState(() => _country = v),
                ),
                const SizedBox(height: 32),
                ElevatedButton(onPressed: _save, child: const Text('Save Profile')),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: _signOut,
                  child: const Text('Sign Out', style: TextStyle(color: ClivoraColors.errorRed)),
                ),
              ],
            ),
    );
  }
}
