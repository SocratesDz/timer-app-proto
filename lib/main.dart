import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_app_proto/stopwatch.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Timer'),
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
  CustomStopwatch _stopwatch;
  Timer _timer;
  int _seconds = 0;
  int _minutes = 0;

  @override
  void initState() {
    super.initState();
    _stopwatch = CustomStopwatch();
  }

  void _startTimer() {
    setState(() {
      _stopwatch.start();
      _timer = Timer.periodic(Duration(seconds: 1), (_) => _updateTimer());
    });
  }

  void _stopTimer() {
    setState(() {
      _stopwatch.stop();
      _stopwatch.reset();
      _timer?.cancel();
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
    final dateTime = DateTime.now();

    // Save time
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("startTime", dateTime.millisecondsSinceEpoch);
  }

  void _loadStartTime() async {
    // Get time
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final milisecondsTime = prefs.getInt("startTime");

    // Show the time state

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
        child: new Icon(_stopwatch.isRunning ? Icons.stop : Icons.play_arrow),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
