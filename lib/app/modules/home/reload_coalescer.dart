import 'dart:async';

/// Collapses a burst of box notifications into one reload.
///
/// Writes to the journals box arrive in bursts: a backup restore writes every
/// entry in turn, and a save can raise more than one notification. Reloading
/// once per notification copies the whole box, resolves every asset and runs
/// `toPlainText` on every entry, so the burst is coalesced into a single reload
/// once the writes stop.
class ReloadCoalescer {
  ReloadCoalescer({
    required this.onFire,
    this.window = const Duration(milliseconds: 300),
  });

  /// Runs the reload.
  final void Function() onFire;

  /// How long to wait after the last [schedule] before reloading.
  final Duration window;

  Timer? _timer;

  /// Restarts the window. Several calls inside the window produce one [onFire].
  void schedule() {
    _timer?.cancel();
    _timer = Timer(window, _fire);
  }

  /// Cancels a pending reload.
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }

  void _fire() {
    _timer = null;
    onFire();
  }
}