import 'dart:math' show Random, max, min;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_view/MySliverGridDelegate.dart';
import 'package:flutter_staggered_view/rect_getter.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
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
  List<int> data = new List<int>.generate(100, (index) => index);
  Random random = new Random();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new GridView.builder(
        itemCount: data.length,
        gridDelegate: new MySliverGridDelegate(rowCount: 2, screenWidth: size.width, viewportHeight: size.height),
        itemBuilder: (BuildContext context, int index) {
          print('build : $index');
          var rectGetter = new RectGetter.defaultKey(
            child: new SizedBox(
              width: random.nextInt(100) + 30.0,
              height: random.nextInt(100) + 30.0,
              child: new Container(
                color: Colors.primaries[index % Colors.primaries.length],
                child: new Center(
                  child: new Text('$index'),
                ),
              ),
            ),
          );
          return new Container(
            color: Colors.primaries[Colors.primaries.length - (index % Colors.primaries.length) - 1],
            child: new Center(
              child: new GestureDetector(
                onTap: () {
                  print(rectGetter.getRect());
                },
                child: rectGetter,
              ),
            ),
          );
        },
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
