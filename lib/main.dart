import 'dart:math' show Random;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
    var screenWidth = MediaQuery.of(context).size.width;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new GridView.builder(
          itemCount: data.length,
          gridDelegate: new MySliverGridDelegate(rowCount: 2, screenWidth: screenWidth),
          itemBuilder: (BuildContext context, int index) {
            print('build : $index');
            return new SizedBox(
              width: random.nextInt(100) + 30.0,
              height: random.nextInt(100) + 30.0,
              child: new Container(
                color: Colors.primaries[index % Colors.primaries.length],
                child: new Center(
                  child: new Text('$index'),
                ),
              ),
            );
          }),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}

class Height {
  final double top;
  final double bottom;

  const Height(this.top, this.bottom);
}

class MySliverGridDelegate extends SliverGridDelegate {
  List<List<Height>> _tempHeight;
  double _itemWidth;
  int rowCount;

  double screenWidth;

  MySliverGridDelegate({this.rowCount, this.screenWidth}) {
    _tempHeight = new List(rowCount);
    _itemWidth = screenWidth / rowCount;
    for (var i = 0; i < rowCount; i++) {
      _tempHeight.add(new List<Height>());
    }
  }

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    return new MySliverGridLayout(_tempHeight);
  }

  @override
  bool shouldRelayout(SliverGridDelegate oldDelegate) {
    return oldDelegate != this;
  }
}

@immutable
class MySliverGridLayout extends SliverGridLayout {
  final List<List<Height>> tempHeight;

  MySliverGridLayout(this.tempHeight);

  @override
  double computeMaxScrollOffset(int childCount) {
    // TODO: implement computeMaxScrollOffset
    return 0.0;
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    // TODO: implement getGeometryForChildIndex
    return new SliverGridGeometry(crossAxisExtent: 0.0, crossAxisOffset: 0.0, mainAxisExtent: 0.0, scrollOffset: 0.0);
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    // TODO: implement getMaxChildIndexForScrollOffset
    return 0;
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    // TODO: implement getMinChildIndexForScrollOffset
    return 0;
  }
}
