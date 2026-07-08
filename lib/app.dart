import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'core/auth/auth_service.dart';
import 'core/services/admin_sync_service.dart';
import 'core/services/automation_service.dart';
import 'core/services/billing_service.dart';
import 'core/services/biometric_service.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/contract_sync_service.dart';
import 'core/services/local_notification_service.dart';
import 'core/services/push_notification_service.dart';
import 'core/services/subscription_manager.dart';
import 'core/services/sync_outbox_service.dart';
import 'core/services/task_reminder_service.dart';
import 'core/services/locale_service.dart';
import 'core/services/telemetry_service.dart';
import 'core/utils/crm_refresh.dart';
import 'core/auth/user_roles.dart';
import 'core/theme/clivora_theme.dart';
import 'data/providers/app_providers.dart';
import 'l10n/app_localizations.dart';
import 'routing/app_router.dart';

class ClivoraApp extends ConsumerStatefulWidget {
  const ClivoraApp({super.key});

  @override
  ConsumerState<ClivoraApp> createState() => _ClivoraAppState();
}

class _ClivoraAppState extends ConsumerState<ClivoraApp> with WidgetsBindingObserver {
  bool _wasPaused = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final bio = ref.read(biometricServiceProvider);
    if (state == AppLifecycleState.paused) {
      _wasPaused = true;
      bio.markBackgrounded();
    } else if (state == AppLifecycleState.resumed && _wasPaused) {
      _wasPaused = false;
      _handleResumeUnlock();
    }
  }

  Future<void> _handleResumeUnlock() async {
    final bio = ref.read(biometricServiceProvider);
    if (!await bio.shouldPromptUnlock()) return;
    final ok = await bio.authenticate(reason: 'Unlock CLIVORA');
    if (!ok && mounted) {
      await ref.read(authStateProvider.notifier).signOut();
      if (mounted) context.go('/login');
    }
  }

  Future<void> _bootstrap() async {
    await ref.read(telemetryServiceProvider).initialize();
    InAppPurchase.instance.purchaseStream.listen((purchases) {
      ref.read(billingServiceProvider).handlePurchaseUpdates(purchases);
    });
    await ref.read(localNotificationServiceProvider).initialize();
    ref.read(connectivityServiceProvider).startListening((online) async {
      if (online) {
        await _onBackOnline();
      }
    });
    final plan = await SubscriptionManager.effectivePlan();
    await ref.read(planLimitServiceProvider).setPlan(plan);
    await ref.read(automationServiceProvider).runWeeklySummaryIfDue();
    await ref.read(automationServiceProvider).runInactiveClientCheckIfDue();
    await ref.read(pushNotificationServiceProvider).initialize();
    await ref.read(syncOutboxServiceProvider).processQueue();
    await ref.read(syncOutboxServiceProvider).reconcileInvoiceShares();
    await ref.read(contractSyncServiceProvider).reconcileSignedContracts();
    ref.read(adminSyncServiceProvider).syncPendingEvents();
    await ref.read(taskReminderServiceProvider).syncAllForCurrentUser();
  }

  Future<void> _onBackOnline() async {
    invalidateOnReconnect(ref);
    await ref.read(syncOutboxServiceProvider).processQueue();
    await ref.read(syncOutboxServiceProvider).reconcileInvoiceShares();
    await ref.read(contractSyncServiceProvider).reconcileSignedContracts();
    ref.read(adminSyncServiceProvider).syncPendingEvents();
    await ref.read(taskReminderServiceProvider).syncAllForCurrentUser();
    invalidateOnReconnect(ref);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(appLocaleProvider);
    final user = ref.watch(authStateProvider).valueOrNull;
    final portal = isClientUser(user) ? ClivoraPortal.client : ClivoraPortal.freelancer;

    return MaterialApp.router(
      title: 'CLIVORA',
      debugShowCheckedModeBanner: false,
      theme: ClivoraTheme.light(portal: portal),
      darkTheme: ClivoraTheme.dark(portal: portal),
      themeMode: themeMode,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: appRouter,
      builder: (context, child) {
        final scale = MediaQuery.textScalerOf(context);
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: scale.clamp(minScaleFactor: 0.85, maxScaleFactor: 1.35),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
