import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth_route_helper.dart';
import 'auth_service.dart';

/// Navigate home after auth, or show a clear error if session did not stick.
void navigateAfterAuth(BuildContext context, WidgetRef ref) {
  final user = ref.read(authStateProvider).valueOrNull;
  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Sign-in succeeded but session could not start. Please try again or reinstall the app.',
        ),
      ),
    );
    return;
  }
  context.go(homeRouteForUser(user));
}

String? authErrorMessage(Object error) {
  final text = error.toString();
  if (text.contains('Null check operator')) {
    return 'Profile data could not be loaded. Try again or use Continue as Guest.';
  }
  if (text.contains('UNIQUE constraint failed')) {
    return 'An account with this email already exists. Try signing in instead.';
  }
  return text.replaceFirst('Exception: ', '').replaceFirst('StateError: ', '');
}
