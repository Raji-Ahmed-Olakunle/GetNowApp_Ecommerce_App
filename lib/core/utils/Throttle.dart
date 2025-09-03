import 'dart:async';

class Throttle {
  final Duration duration;
  DateTime? _lastCallTime;
  Timer? _timer;

  Throttle(this.duration);

  void call(Function() callback) {
    final now = DateTime.now();

    if (_lastCallTime == null || now.difference(_lastCallTime!) >= duration) {
      // Execute immediately if enough time has passed
      _lastCallTime = now;
      callback();
    } else {
      // Schedule execution for when the throttle period ends
      _timer?.cancel();
      _timer = Timer(duration - now.difference(_lastCallTime!), () {
        _lastCallTime = DateTime.now();
        callback();
      });
    }
  }

  void cancel() {
    _timer?.cancel();
    _lastCallTime = null;
  }
}
