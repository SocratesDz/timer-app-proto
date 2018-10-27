class CustomStopwatch {
  DateTime _startTime;
  bool _isRunning;
  DateTime _endTime;
  int elapsedTime;

  Duration get elapsed => (_isRunning ? _now : _endTime).difference(_startTime);

  bool get isRunning => _isRunning;

  DateTime get _now => DateTime.now();
  
  void start() {
    _startTime = _now.subtract(_now.difference(_endTime));
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
    if(elapsedTime != null) {
      _startTime.add(Duration(milliseconds: elapsedTime));
    }
  }
}