import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_app_proto/stopwatch.dart';
import 'package:timer_app_proto/task_list_screen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskListScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _stopwatch = CustomStopwatch();
  Timer _timer;
  int _seconds = 0;
  int _minutes = 0;

  @override
  void initState() {
    super.initState();
    _loadStartTime();
  }

  void _startTimer() {
    setState(() {
      _stopwatch.start();
      _timer = Timer.periodic(Duration(seconds: 1), (_) => _updateTimer());
      _saveStartTime();
    });
  }

  void _stopTimer() {
    setState(() {
      _stopwatch.stop();
      _timer?.cancel();
      _saveStartTime();
    });
  }

  void _updateTimer() {
    setState(() {
      _seconds = _stopwatch.elapsed.inSeconds % 60;
      _minutes = _stopwatch.elapsed.inMinutes;
    });
  }

  void _saveStartTime() async {
    // Get time
    final dateTime = _stopwatch.startTime;

    // Save time
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("startTime", dateTime.millisecondsSinceEpoch);
    prefs.setBool("isRunning", _stopwatch.isRunning);
  }

  void _loadStartTime() async {
    // Get time
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final millisecondsTime = prefs.getInt("startTime");
    final isRunning = prefs.getBool("isRunning");
    // Show the time state
    _stopwatch = CustomStopwatch(
        initialMilliseconds: millisecondsTime, shouldStart: isRunning ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final formatSeconds = NumberFormat("00");
    final formatMinutes = NumberFormat("#00");
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              '${formatMinutes.format(_minutes)}:${formatSeconds.format(_seconds)}',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _stopwatch.isRunning ? _stopTimer : _startTimer,
        tooltip: 'Increment',
        child: new Icon(_stopwatch.isRunning ? Icons.pause : Icons.play_arrow),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
