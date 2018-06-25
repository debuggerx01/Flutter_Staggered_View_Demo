import 'dart:async';
import 'dart:math' show pi;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_view/my_scroll_controller.dart';
import 'package:flutter_staggered_view/my_sliver_grid_delegate.dart';
import 'package:rect_getter/rect_getter.dart';

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

  var key = new GlobalKey();

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
    var controller = new MyScrollController(key,
        rowCount: rowCount, screenWidth: size.width, viewportHeight: size.height, itemCount: data.length);
    var delegate = new MySliverGridDelegate(key: controller.key);
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
            child: SizeChangedLayoutNotifier(
              child: index == 0
                  ? new Image.network('http://debuggerx.com:8888/upload/nazou.png')
                  : new Image.network(
                      'https://picsum.photos/${(pi * index * 10000) % 100 + 100.0}/${(pi * index * 1000000) % 100 + 150.0}/?image=$index'),

              /*new SizedBox(
                      width: (pi * index * 10000) % 100 + 100.0,
                      height: (pi * index * 1000000) % 100 + 150.0,
                      child: new Container(
                        color: Colors.primaries[index % Colors.primaries.length],
                        child: new Center(
                          child: new Text('$index'),
                        ),
                      ),
                    ),*/
            ),
          );

          var cell = new NotificationListener<SizeChangedLayoutNotification>(
              onNotification: (notification) {
                new Future.delayed(Duration.zero, () {
                  setState(() {
                    var rect = rectGetter.getRect();
                    rect = rect == null ? Size.zero : rect;
                    controller.chs.updateChild(index, Size(rect.width, rect.height));
                  });
                });
              },
              child: rectGetter);

          new Future.delayed(Duration.zero, () {
            var rect = rectGetter.getRect();
            rect = rect == null ? Size.zero : rect;
            controller.chs.addChild(index: index, width: rect.width, height: rect.height);
            if (controller.chs.childCount != data.length) setState(() {});
          });
          return new FittedBox(
            fit: BoxFit.contain,
            child: cell,
          );
        },
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          controller.chs.list.forEach((hs) {
            print('-------------------------------------------');
            hs.forEach((h) {
              print('${h.index}, ${h.top}, ${h.bottom}');
            });
            print('-------------------------------------------');
          });
          controller.jumpTo(0.0);
          setState(() {
            rowCount = rowCount >= 6 ? 2 : rowCount + 1;
            controller.chs.rebuildList(rowCount, size.width / rowCount);
          });
        },
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
