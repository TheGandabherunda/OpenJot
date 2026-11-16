/// Tells a box notification caused by this controller's own write apart from
/// one caused by somebody else.
///
/// `HomeController` is the only writer that both writes to the box and updates
/// its own lists in place. Without this gate, every one of those writes would
/// come back through the box listener and trigger a full reload, which is the
/// expensive path the gate exists to skip.
///
/// A mark is consumed by exactly one notification. `begin()` twice then
/// `isSelfWrite()` twice consumes both, so a write that raises two
/// notifications does not leave a stale mark that swallows a later change from
/// outside.
class SelfWriteGate {
  int _depth = 0;

  /// Marks the next notification as this controller's own.
  void begin() {
    _depth++;
  }

  /// Reports whether the notification being handled came from a write marked by
  /// [begin], and consumes one mark when it did.
  bool isSelfWrite() {
    if (_depth == 0) return false;
    _depth--;
    return true;
  }

  /// Drops marks the notification did not consume.
  ///
  /// Call this once a write has finished and the box listener has had its turn.
  /// Hive delivers box notifications through a stream, so a mark can outlive the
  /// write that raised it if the box raised nothing; left in place it would make
  /// the next change from outside look self-inflicted and skip its reload.
  void clear() {
    _depth = 0;
  }

  /// Marks still waiting to be consumed.
  int get depth => _depth;
}