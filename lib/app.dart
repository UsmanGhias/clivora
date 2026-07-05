import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'core/services/admin_sync_service.dart';
import 'core/services/automation_service.dart';
import 'core/services/billing_service.dart';
import 'core/theme/clivora_theme.dart';
import 'data/providers/app_providers.dart';
import 'routing/app_router.dart';

class ClivoraApp extends ConsumerStatefulWidget {
  const ClivoraApp({super.key});

  @override
  ConsumerState<ClivoraApp> createState() => _ClivoraAppState();
}

class _ClivoraAppState extends ConsumerState<ClivoraApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    InAppPurchase.instance.purchaseStream.listen((purchases) {
      ref.read(billingServiceProvider).handlePurchaseUpdates(purchases);
    });
    await ref.read(automationServiceProvider).runWeeklySummaryIfDue();
    ref.read(adminSyncServiceProvider).syncPendingEvents();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'CLIVORA',
      debugShowCheckedModeBanner: false,
      theme: ClivoraTheme.light(),
      darkTheme: ClivoraTheme.dark(),
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
