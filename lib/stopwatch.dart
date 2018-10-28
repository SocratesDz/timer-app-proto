class CustomStopwatch {
  DateTime _startTime;
  bool _isRunning;
  DateTime _endTime;
  bool _isStarted;

  Duration get elapsed => (_isRunning ? _now : _endTime).difference(_startTime);

  bool get isRunning => _isRunning;

  DateTime get _now => DateTime.now();

  void start() {
    if(!_isStarted) {
      _startTime = _now;
      _isStarted = true;
    } else {
      final currentTime = _now;
      _startTime = _startTime.subtract(currentTime.difference(_startTime));
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
  }

  CustomStopwatch({int elapsedTime}) {
    reset();
    _isStarted = false;
    if (elapsedTime != null) {
      _startTime.add(Duration(milliseconds: elapsedTime));
    }
  }
}
