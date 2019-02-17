import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timer_app_proto/timer_event.dart';
import 'package:timer_app_proto/timer_isolate.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TimerIsolate _timerIsolate;

  @override
  void initState() {
    super.initState();
    _timerIsolate = TimerIsolate();
  }

  @override
  void dispose() {
    _timerIsolate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Tasks"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: 15,
                  itemBuilder: (context, position) {
                    return ListTile(
                      title: Text("Task #${position + 1}"),
                    );
                  }),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(offset: Offset(0.0, 2.0), blurRadius: 3.0)
              ]),
              child: InkWell(
                onTap: _showTaskDetail,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder<TimerEvent>(
                        initialData: TimerEvent(false, Duration(seconds: 0)),
                        stream: _timerIsolate.timerEvents,
                        builder: (context, snapshot) {
                          return Row(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: FloatingActionButton(
                                  child: new Icon(snapshot.data.isActive
                                      ? Icons.pause
                                      : Icons.play_arrow),
                                  onPressed: snapshot.data.isActive
                                      ? _stopTimer
                                      : _startTimer,
                                ),
                              ),
                              snapshot.hasData
                                  ? Text(
                                      _formatTimeDuration(
                                          snapshot.data.duration),
                                      style:
                                          Theme.of(context).textTheme.display1,
                                    )
                                  : CircularProgressIndicator()
                            ],
                          );
                        })),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showTaskDetail() {
    _scaffoldKey.currentState.showBottomSheet<void>((context) {
      return new Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Bigger Text",
                style: Theme.of(context).textTheme.display2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Another big text",
                style: Theme.of(context).textTheme.display2,
              ),
            )
          ],
        ),
      );
    });
  }

  void _startTimer() async {
    await _timerIsolate.start();
  }

  void _stopTimer() async {
    await _timerIsolate.stop();
  }

  bool _isRunning() => _timerIsolate.isRunning();

  String _formatTimeDuration(Duration duration) {
    final formatSeconds = NumberFormat("00");
    final formatMinutes = NumberFormat("#00");
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;
    return "${formatMinutes.format(minutes)}:${formatSeconds.format(seconds)}";
  }
}
