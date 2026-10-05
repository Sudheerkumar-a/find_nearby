import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/update_providers.dart';
import '../domain/update_gate_result.dart';
import 'update_required_dialog.dart';

/// Silently checks Play for updates when home is visible; shows mandatory dialog.
class HomeUpdateChecker extends ConsumerStatefulWidget {
  const HomeUpdateChecker({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<HomeUpdateChecker> createState() => _HomeUpdateCheckerState();
}

class _HomeUpdateCheckerState extends ConsumerState<HomeUpdateChecker>
    with WidgetsBindingObserver {
  var _checking = false;
  var _dialogOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _silentCheck());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _silentCheck();
    }
  }

  Future<void> _silentCheck({bool performIfAllowed = false}) async {
    if (_checking || _dialogOpen) return;
    _checking = true;
    try {
      final result = await ref
          .read(updateServiceProvider)
          .checkForUpdate(performIfAllowed: performIfAllowed);
      if (!mounted) return;

      if (result.status == UpdateGateStatus.blocked &&
          result.storeUrl != null &&
          result.storeUrl!.isNotEmpty) {
        await _showMandatoryDialog(result);
      }
    } finally {
      _checking = false;
    }
  }

  Future<void> _showMandatoryDialog(UpdateGateResult result) async {
    if (_dialogOpen || !mounted) return;
    _dialogOpen = true;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: UpdateRequiredDialog(
          storeUrl: result.storeUrl!,
          message: result.message,
          onRetry: () => _silentCheck(performIfAllowed: true),
        ),
      ),
    );

    _dialogOpen = false;
    if (mounted) _silentCheck();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
