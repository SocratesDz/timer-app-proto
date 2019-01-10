import 'dart:async';
import 'dart:isolate';

class TimerIsolate {
  final _durationStream = StreamController<Duration>();
  static Timer _timer;
  Isolate _timerIsolate;

  bool get isRunning => _timer?.isActive ?? false;
  Stream<Duration> get duration => _durationStream.stream;

  start() async {
    if(isRunning) {
      stop();
    }

    ReceivePort receivePort = ReceivePort();
    _timerIsolate = await Isolate.spawn(_launchTimer, receivePort.sendPort);
    SendPort sendPort = await receivePort.first;
    Stream<Duration> duration = _sendReceive(sendPort, Duration(seconds: 0));
    _durationStream.addStream(duration);
  }

  stop() async {
    if(_timer.isActive) {
      _timer?.cancel();
      _timerIsolate?.kill();
    }
  }

  static _launchTimer(SendPort startTimerPort) async {
    ReceivePort port = ReceivePort();
    startTimerPort.send(port.sendPort);

    final message = await port.first;
    Duration currentDuration = message[0];
    SendPort replyTo = message[1];
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final duration = Duration(seconds: currentDuration.inSeconds+1);
      replyTo.send(duration);
    });
  }

  Stream<Duration> _sendReceive(SendPort sendPort, Duration initialDuration) {
    ReceivePort response = ReceivePort();
    sendPort.send([initialDuration, response.sendPort]);
    return response.map((value) => value as Duration).asBroadcastStream();
  }

  void dispose() {
    _durationStream.close();
  }
}