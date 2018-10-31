class CustomStopwatch {
  DateTime _startTime;
  bool _isRunning = false;
  DateTime _endTime;
  bool _isStarted = false;

  DateTime get startTime => _startTime;

  Duration get elapsed => (_isRunning ? _now : _endTime).difference(_startTime);

  bool get isRunning => _isRunning;

  DateTime get _now => DateTime.now();

  void start() {
    if (_isRunning == true) return;
    if (!_isStarted) {
      _startTime = _now;
      _isStarted = true;
    } else {
      _startTime = _now.subtract(_endTime.difference(_startTime));
    }
    _isRunning = true;
  }

  void stop() {
    _endTime = _now;
    _isRunning = false;
  }

  void reset() {
    _startTime = _now;
    _endTime = _now;
    _isRunning = false;
    _isStarted = false;
  }

  CustomStopwatch({int initialMilliseconds, bool shouldStart = false}): assert(shouldStart != null) {
    reset();
    if (initialMilliseconds != null) {
      _startTime = DateTime.fromMillisecondsSinceEpoch(initialMilliseconds);
    }
    _isStarted = shouldStart;
    _isRunning = shouldStart;
  }
}
