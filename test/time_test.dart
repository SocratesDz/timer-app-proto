import 'package:flutter_test/flutter_test.dart';
import 'package:timer_app_proto/timer_isolate.dart';

void main() {
  test('Test date operations', () {
    final date1 = DateTime.now().subtract(Duration(minutes: 10));
    print(date1.toIso8601String());
    expect(DateTime.now().difference(date1).inMinutes, 10);
  });

  test('Test timer isolate.', () async {
    final timerIsolate = TimerIsolate();
    await timerIsolate.start();
    var event = await timerIsolate.timerEvents.first;
    expect(event.isActive, true);

    await Future.delayed(Duration(seconds: 5));

    await timerIsolate.stop();
    event = await timerIsolate.timerEvents.last;
    expect(event.isActive, false);
  });
}