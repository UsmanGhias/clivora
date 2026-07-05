import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/clivora_colors.dart';

class ClivoraScaffold extends StatelessWidget {
  const ClivoraScaffold({
    super.key,
    required this.title,
    required this.body,
    this.action,
    this.showBackButton = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.floatingActionButton,
  });

  final String title;
  final Widget body;
  final Widget? action;
  final bool showBackButton;
  final EdgeInsets padding;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: padding,
              child: Row(
                children: [
                  if (showBackButton)
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).cardColor,
                      ),
                    ),
                  if (showBackButton) const SizedBox(width: 8),
                  Expanded(
                    child: Text(title, style: Theme.of(context).textTheme.headlineLarge),
                  ),
                  if (action != null) action!,
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: padding,
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
    return Material(
      color: Theme.of(context).brightness == Brightness.light
          ? ClivoraColors.chipBackground
          : ClivoraColors.darkBorder,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, size: 22),
        ),
      ),
    );
  }
}
