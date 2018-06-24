import 'dart:async';
import 'dart:math' show pi;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_view/children_heights.dart';
import 'package:flutter_staggered_view/my_sliver_grid_delegate.dart';
import 'package:flutter_staggered_view/rect_getter.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      /*   title: 'Flutter Demo',*/
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
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
  int rowCount = 3;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /// release模式下启动速度过快，可能导致取得的屏幕宽高为0
    if (size.height == 0.0) {
      new Future.delayed(Duration.zero, () {
        setState(() {});
      });
      return new Container();
    }
    var controller = new ScrollController();
    var delegate = new MySliverGridDelegate(
        rowCount: rowCount, screenWidth: size.width, viewportHeight: size.height, itemCount: data.length);
    return new Scaffold(
/*      appBar: new AppBar(
        title: new Text(widget.title),
      ),*/
      body: new GridView.builder(
        controller: controller,
        itemCount: data.length,
        gridDelegate: delegate,
//        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
        itemBuilder: (BuildContext context, int index) {
          print('build : $index');

          var rectGetter = new RectGetter.defaultKey(
            child: new SizedBox(
              width: (pi * index * 10000) % 100 + 100.0,
              height: (pi * index * 1000000) % 100 + 150.0,
              child: new Container(
                color: Colors.primaries[index % Colors.primaries.length],
                child: new Center(
                  child: new Text('$index'),
                ),
              ),
            ),
          );

          new Future.delayed(Duration.zero, () {
            var rect = rectGetter.getRect();
            new ChildrenHeights().addChild(index: index, width: rect.width, height: rect.height);
//            controller.animateTo(controller.offset + (index.isOdd ? 1.0 : -1.0),
//                duration: const Duration(microseconds: 1), curve: Curves.linear);

            if (ChildrenHeights().childCount != data.length) setState(() {});
          });
          return new FittedBox(
            fit: BoxFit.contain,
            child: rectGetter,
          );
        },
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          var ch = new ChildrenHeights();
          ch.list.forEach((hs) {
            print('-------------------------------------------');
            hs.forEach((h) {
              print('${h.index}, ${h.top}, ${h.bottom}');
            });
            print('-------------------------------------------');
          });
          controller.jumpTo(0.0);
          setState(() {
            rowCount = rowCount >= 6 ? 2 : rowCount + 1;
          });
        },
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
