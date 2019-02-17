import 'dart:async';
import 'dart:isolate';

import 'package:timer_app_proto/timer_event.dart';

class TimerIsolate {
  final _timerEventStream = StreamController<TimerEvent>.broadcast();
  final _timerStatusStream = StreamController<bool>();
  bool isActive = false;
  Isolate _timerIsolate;
  static Timer _timer;

  bool isRunning() => isActive;

  Stream<TimerEvent> get timerEvents =>
      _timerEventStream.stream.asBroadcastStream();

  TimerIsolate() {
    _timerStatusStream.stream.listen((bool active) {
      isActive = active;
    });
  }

  Future<void> start() async {
    try {
      if (isRunning()) {
        stop();
      }

      ReceivePort receivePort = ReceivePort();
      _timerIsolate = await Isolate.spawn(_launchTimer, receivePort.sendPort);
      SendPort sendPort = await receivePort.first;
      Stream<TimerEvent> duration =
      _sendReceive(sendPort, TimerEvent(false, Duration(seconds: 0)));
      _timerEventStream.addStream(duration);
      _timerStatusStream.add(true);
    } catch(ex) {
      print(ex);
    }
  }

  Future<void> stop() async {
    try {
      _timerIsolate?.kill();
      _timer?.cancel();
      final lastDuration = await _timerEventStream.stream.last;
      _timerEventStream.sink.add(TimerEvent(false, lastDuration.duration));
      _timerStatusStream.sink.add(false);
    } catch(ex) {
      print(ex);
    }
  }

  static Future<void> _launchTimer(SendPort startTimerPort) async {
    ReceivePort port = ReceivePort();
    startTimerPort.send(port.sendPort);

    final message = await port.first;
    TimerEvent currentDuration = message[0];
    SendPort replyTo = message[1];
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      currentDuration = TimerEvent(
          true, Duration(seconds: currentDuration.duration.inSeconds + 1));
      replyTo.send(currentDuration);
    });
  }

  Stream<TimerEvent> _sendReceive(
      SendPort sendPort, TimerEvent initialDuration) {
    ReceivePort response = ReceivePort();
    sendPort.send([initialDuration, response.sendPort]);
    return response.map((value) => value as TimerEvent).asBroadcastStream();
  }

  void dispose() {
    _timerEventStream.close();
    _timerStatusStream.close();
  }
}
