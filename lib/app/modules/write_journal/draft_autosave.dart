import 'dart:async';

/// Decides when an editor draft is written to storage.
///
/// It owns the timing and nothing else: what counts as a change, what a draft
/// is, and how it is written all belong to the caller. A change restarts the
/// idle timer rather than queueing a save per keystroke, `flush` writes at most
/// once, and `discard` cancels without writing.
class DraftAutosave {
  DraftAutosave({
    required this.save,
    this.idle = const Duration(seconds: 2),
  });

  /// Writes the draft. Injected, so the timing can be tested without storage.
  final Future<void> Function() save;
  final Duration idle;

  Timer? _timer;
  bool _pending = false;
  bool _inFlight = false;
  bool _disposed = false;

  /// Whether a change is waiting to be written.
  bool get hasPendingChanges => _pending;

  /// Records a change and restarts the idle timer.
  void noteChange() {
    if (_disposed) return;
    _pending = true;
    _timer?.cancel();
    _timer = Timer(idle, _run);
  }

  /// Writes a pending change now, if there is one, and cancels the timer.
  ///
  /// Safe to call from a lifecycle callback and from `dispose`: with nothing
  /// pending it does nothing, and calling it twice writes once.
  Future<void> flush() async {
    _timer?.cancel();
    _timer = null;
    if (!_pending) return;
    await _run();
  }

  /// Cancels the pending write, for a save or a discard the user completed.
  void discard() {
    _timer?.cancel();
    _timer = null;
    _pending = false;
  }

  /// Releases the timer. Further changes are ignored.
  void dispose() {
    _disposed = true;
    discard();
  }

  Future<void> _run() async {
    _timer = null;
    if (!_pending) return;
    // A write is already running: wait for it rather than racing it, and keep
    // the change pending so the next tick picks it up.
    if (_inFlight) {
      _timer = Timer(idle, _run);
      return;
    }
    _pending = false;
    _inFlight = true;
    try {
      await save();
    } finally {
      _inFlight = false;
    }
  }
}