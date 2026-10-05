import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/update_providers.dart';
import '../domain/update_gate_result.dart';
import 'update_required_dialog.dart';

/// Checks Google Play for updates on launch and resume; blocks when required.
class UpdateListener extends ConsumerStatefulWidget {
  const UpdateListener({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<UpdateListener> createState() => _UpdateListenerState();
}

class _UpdateListenerState extends ConsumerState<UpdateListener>
    with WidgetsBindingObserver {
  UpdateGateResult? _blocked;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkForUpdate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkForUpdate();
    }
  }

  Future<void> _checkForUpdate() async {
    final result = await ref.read(updateServiceProvider).checkForUpdate();
    if (!mounted) return;

    setState(() {
      switch (result.status) {
        case UpdateGateStatus.blocked:
          _blocked = result;
        case UpdateGateStatus.upToDate:
          _blocked = null;
        case UpdateGateStatus.updating:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final blocked = _blocked;
    final showDialog =
        blocked != null &&
        blocked.storeUrl != null &&
        blocked.storeUrl!.isNotEmpty;

    return PopScope(
      canPop: !showDialog,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AbsorbPointer(absorbing: showDialog, child: widget.child),
          if (showDialog) ...[
            ModalBarrier(
              dismissible: false,
              color: Colors.black.withValues(alpha: 0.45),
            ),
            Center(
              child: UpdateRequiredDialog(
                storeUrl: blocked.storeUrl!,
                message: blocked.message,
                onRetry: _checkForUpdate,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
