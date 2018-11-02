import 'package:flutter/material.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
              decoration: BoxDecoration(
                color: Colors.white,
                  boxShadow: [BoxShadow(offset: Offset(0.0, 2.0), blurRadius: 3.0)]),
              child: InkWell(
                onTap: _showTaskDetail,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: FloatingActionButton(
                          child: Icon(Icons.play_arrow),
                          onPressed: () {},
                        ),
                      ),
                      Text(
                        "0:00",
                        style: Theme.of(context).textTheme.display1,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showTaskDetail() {
    _scaffoldKey.currentState.showBottomSheet<void>((context) {
      return new Container(child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Bigger Text", style: Theme.of(context).textTheme.display2,),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Another big text", style: Theme.of(context).textTheme.display2,),
        )
      ],),);
    });
  }
}
