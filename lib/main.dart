import 'dart:async';
import 'dart:math' show pi;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_view/scroll_controller_for_staggered_view.dart';
import 'package:flutter_staggered_view/sliver_grid_delegate_for_staggered_view.dart';
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
  List<int> data = new List<int>.generate(10, (index) => index);
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
    var controller = new ScrollControllerForStaggeredView(key,
        rowCount: rowCount, screenWidth: size.width, viewportHeight: size.height, itemCount: data.length);
    var delegate = new SliverGridDelegateForStaggeredView(key: controller.key);

    void _loadMore() {
      if (controller.chs.renderedCount < data.length || controller.offset == 0.0) return;
      var last = data.last + 1;
      data.addAll(List.generate(10, (index) => index + last).toList());
      print('add data : $data');
      Timer(Duration(milliseconds: 100), () {
        controller.jumpTo(controller.offset - 1.0);
        setState(() {});
      });
    }

    return new Scaffold(
/*      appBar: new AppBar(
        title: new Text(widget.title),
      ),*/
      body: NotificationListener<OverscrollNotification>(
        onNotification: (notification) {
          _loadMore();
        },
        child: new GridView.builder(
          controller: controller,
          itemCount: data.length,
          gridDelegate: delegate,
          itemBuilder: (BuildContext context, int index) {
            var width = ((pi * index * 10000) % 100 + 100).toInt();
            var height = ((pi * index * 1000000) % 100 + 150).toInt();

            var rectGetter = new RectGetter.defaultKey(
              child: SizeChangedLayoutNotifier(
                child: Card(
                  margin: EdgeInsets.all(1.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 200.0,
                        color: Colors.blue,
                        child: Center(
                          child: Text(
                            '$width\X$height',
                            style: const TextStyle(fontSize: 24.0),
                          ),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          SizedBox(
                            width: 200.0,
                            child: FadeInImage(
                              fit: BoxFit.fitWidth,
                              placeholder: AssetImage('logo.png'),
                              image: new NetworkImage('https://picsum.photos/$width/$height/?image=$index'),
                            ),
                          ),
                          Container(
                            width: 200.0,
                            color: Colors.grey.withOpacity(0.5),
                            child: Center(
                              child: Text(
                                '$index',
                                style: const TextStyle(fontSize: 24.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );

            /// 这个尺寸变化监听在setState过程中并不可靠！！！
            var cell = new NotificationListener<SizeChangedLayoutNotification>(
                onNotification: (notification) {
                  print('$index changed');
                  new Future.delayed(Duration(milliseconds: 100), () {
                    setState(() {
                      var rect = rectGetter.getRect();
                      rect = rect == null ? Rect.zero : rect;
                      controller.chs.updateChild(index, Size(rect.width, rect.height));
                    });
                  });
                },
                child: rectGetter);

            new Future.delayed(Duration.zero, () {
              var rect = rectGetter.getRect();
              rect = rect == null ? Rect.zero : rect;
              controller.chs.updateChild(index, Size(rect.width, rect.height));
              if (controller.chs.renderedCount == data.length - 1) setState(() {});
            });
            return new FittedBox(
              fit: BoxFit.contain,
              child: cell,
            );
          },
        ),
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
