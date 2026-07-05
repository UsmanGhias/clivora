import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Opens create/edit screens immediately. Plan limits are enforced on save only.
void openFormRoute(BuildContext context, String path) {
  context.push(path);
}

Future<bool> tryOpenWithPlanCheck(
  BuildContext context, {
  required WidgetRef ref,
  required Future<bool> Function() canAdd,
  required String path,
  required String resource,
  required int max,
}) async {
  openFormRoute(context, path);
  return true;
}
