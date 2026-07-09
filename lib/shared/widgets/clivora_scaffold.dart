import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/clivora_tokens.dart';
import '../../core/theme/theme_context.dart';
import 'messages_icon_button.dart';

class ClivoraScaffold extends StatelessWidget {
  const ClivoraScaffold({
    super.key,
    required this.title,
    required this.body,
    this.action,
    this.showBackButton = false,
    this.showMessagesButton = false,
    this.messagesRoute = '/freelancer-messages',
    this.padding,
    this.floatingActionButton,
  });

  final String title;
  final Widget body;
  final Widget? action;
  final bool showBackButton;
  final bool showMessagesButton;
  final String messagesRoute;
  final EdgeInsets? padding;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final layout = context.clivoraLayout;
    final screenPadding = padding ??
        EdgeInsets.symmetric(horizontal: layout.screenPadding);

    return Scaffold(
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: screenPadding,
              child: Row(
                children: [
                  if (showBackButton) ...[
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    ),
                    const SizedBox(width: ClivoraSpacing.sm),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  if (showMessagesButton) ...[
                    MessagesIconButton(route: messagesRoute),
                    if (action != null) const SizedBox(width: ClivoraSpacing.md),
                  ],
                  if (action != null) action!,
                ],
              ),
            ),
            const SizedBox(height: ClivoraSpacing.sm),
            Expanded(
              child: Padding(
                padding: screenPadding,
                child: body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClivoraIconButton extends StatelessWidget {
  const ClivoraIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 22),
    );
  }
}
