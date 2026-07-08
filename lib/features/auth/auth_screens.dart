import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_navigation.dart';
import '../../core/services/referral_service.dart';
import '../../core/services/last_login_service.dart';
import '../../core/auth/auth_service.dart';
import '../../core/auth/user_roles.dart';
import '../../core/theme/clivora_colors.dart';
import '../../core/utils/user_messages.dart';
import '../../shared/widgets/clivora_logo.dart';
import 'widgets/account_type_selector.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  String _accountType = kAccountFreelancer;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showRoleMismatchIfNeeded() {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null || isAdminUser(user) || isGuestUser(user)) return;
    final expectedClient = _accountType == kAccountClient;
    final actualClient = isClientUser(user);
    if (expectedClient != actualClient) {
      ClivoraUserMessages.showRoleMismatch(context, actualRole: accountTypeLabel(user));
    }
  }

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      final error = await ref.read(authStateProvider.notifier).signIn(
            email: _emailController.text,
            password: _passwordController.text,
            loginAsType: _accountType,
          );
      if (!mounted) return;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
        return;
      }
      _showRoleMismatchIfNeeded();
      await LastLoginService.record('email');
      navigateAfterAuth(context, ref);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authErrorMessage(e) ?? 'Sign in failed')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _guestSignIn() async {
    setState(() => _loading = true);
    try {
      final error = await ref.read(authStateProvider.notifier).signInAsGuest(
            accountType: _accountType,
          );
      if (!mounted) return;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
        return;
      }
      final user = ref.read(authStateProvider).valueOrNull;
      if (user != null && !isAdminUser(user) && !isGuestUser(user)) {
        final expectedClient = _accountType == kAccountClient;
        if (expectedClient != isClientUser(user)) {
          ClivoraUserMessages.showRoleMismatch(context, actualRole: accountTypeLabel(user));
        }
      }
      navigateAfterAuth(context, ref);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authErrorMessage(e) ?? 'Guest mode failed')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your email above, then tap Forgot password')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      final error = await ref.read(authStateProvider.notifier).resetPasswordForEmail(email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error ?? 'Password reset email sent. Check your inbox for $email',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _googleSignIn() async {
    setState(() => _loading = true);
    try {
      final error = await ref.read(authStateProvider.notifier).signInWithGoogle(
            accountType: _accountType,
          );
      if (!mounted) return;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
        return;
      }
      _showRoleMismatchIfNeeded();
      await LastLoginService.record('google');
      navigateAfterAuth(context, ref);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authErrorMessage(e) ?? 'Google sign-in failed')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 40),
            const Center(child: ClivoraLogo(size: 88, borderRadius: 24)),
            const SizedBox(height: 16),
            Text(
              'CLIVORA — your business OS for freelancers and clients',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: ClivoraColors.primaryPurple),
            ),
            const SizedBox(height: 8),
            Text(
              'Welcome back',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _accountType == kAccountClient
                  ? 'Sign in to view shared projects'
                  : 'Sign in to manage your business',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ClivoraColors.textSecondary),
            ),
            const SizedBox(height: 24),
            AccountTypeSelector(
              selected: _accountType,
              onChanged: (v) => setState(() => _accountType = v),
              compact: true,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'EMAIL',
                hintText: 'you@business.com',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: 'PASSWORD',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _loading ? null : _forgotPassword,
                child: const Text('Forgot password?'),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _login,
              child: _loading
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Sign In'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: Divider(color: Theme.of(context).dividerColor)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('or', style: Theme.of(context).textTheme.bodySmall),
                ),
                Expanded(child: Divider(color: Theme.of(context).dividerColor)),
              ],
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _loading ? null : _googleSignIn,
              icon: const Icon(Icons.g_mobiledata, size: 28),
              label: const Text('Continue with Google'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _loading ? null : _guestSignIn,
              child: const Text('Continue as Guest'),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?", style: Theme.of(context).textTheme.bodySmall),
                TextButton(
                  onPressed: () => context.go('/signup'),
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _referralController = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  String _accountType = kAccountFreelancer;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    setState(() => _loading = true);
    try {
      final error = await ref.read(authStateProvider.notifier).signUp(
            name: _nameController.text,
            email: _emailController.text,
            password: _passwordController.text,
            accountType: _accountType,
          );
      if (!mounted) return;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
        return;
      }
      if (_referralController.text.trim().isNotEmpty) {
        await ref.read(referralServiceProvider).applyReferralCode(_referralController.text);
      }
      final user = ref.read(authStateProvider).valueOrNull;
      if (user != null && !isAdminUser(user) && !isGuestUser(user)) {
        final expectedClient = _accountType == kAccountClient;
        if (expectedClient != isClientUser(user)) {
          ClivoraUserMessages.showRoleMismatch(context, actualRole: accountTypeLabel(user));
        }
      }
      navigateAfterAuth(context, ref);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authErrorMessage(e) ?? 'Sign up failed')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _guestSignUp() async {
    setState(() => _loading = true);
    try {
      final error = await ref.read(authStateProvider.notifier).signInAsGuest(
            accountType: _accountType,
          );
      if (!mounted) return;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
        return;
      }
      final user = ref.read(authStateProvider).valueOrNull;
      if (user != null && !isAdminUser(user) && !isGuestUser(user)) {
        final expectedClient = _accountType == kAccountClient;
        if (expectedClient != isClientUser(user)) {
          ClivoraUserMessages.showRoleMismatch(context, actualRole: accountTypeLabel(user));
        }
      }
      navigateAfterAuth(context, ref);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authErrorMessage(e) ?? 'Guest mode failed')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _googleSignUp() async {
    setState(() => _loading = true);
    try {
      final error = await ref.read(authStateProvider.notifier).signInWithGoogle(
            accountType: _accountType,
          );
      if (!mounted) return;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
        return;
      }
      if (_referralController.text.trim().isNotEmpty) {
        await ref.read(referralServiceProvider).applyReferralCode(_referralController.text);
      }
      final user = ref.read(authStateProvider).valueOrNull;
      if (user != null && !isAdminUser(user) && !isGuestUser(user)) {
        final expectedClient = _accountType == kAccountClient;
        if (expectedClient != isClientUser(user)) {
          ClivoraUserMessages.showRoleMismatch(context, actualRole: accountTypeLabel(user));
        }
      }
      navigateAfterAuth(context, ref);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authErrorMessage(e) ?? 'Google sign-up failed')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 24),
            Row(
              children: [
                IconButton(
                  onPressed: () => context.go('/login'),
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                ),
                const Expanded(
                  child: Text('Create Account', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 24),
            const Center(child: ClivoraLogo(size: 72, borderRadius: 20)),
            const SizedBox(height: 24),
            AccountTypeSelector(
              selected: _accountType,
              onChanged: (v) => setState(() => _accountType = v),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'FULL NAME', hintText: 'Your name', prefixIcon: Icon(Icons.person_outline)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'EMAIL', hintText: 'you@business.com', prefixIcon: Icon(Icons.email_outlined)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: 'PASSWORD',
                hintText: 'At least 6 characters',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                'Use 6+ characters with letters and numbers for a stronger password.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ClivoraColors.textSecondary),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _referralController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'REFERRAL CODE (optional)',
                hintText: 'CLIVORAXXXXXX',
                prefixIcon: Icon(Icons.card_giftcard_outlined),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _signup,
              child: _loading
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Create Account'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: Divider(color: Theme.of(context).dividerColor)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('or', style: Theme.of(context).textTheme.bodySmall),
                ),
                Expanded(child: Divider(color: Theme.of(context).dividerColor)),
              ],
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _loading ? null : _googleSignUp,
              icon: const Icon(Icons.g_mobiledata, size: 28),
              label: const Text('Sign up with Google'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _loading ? null : _guestSignUp,
              child: const Text('Continue as Guest'),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?', style: Theme.of(context).textTheme.bodySmall),
                TextButton(onPressed: () => context.go('/login'), child: const Text('Sign In')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
