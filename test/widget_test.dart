// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter/material.dart';
import 'package:flutter_staggered_view/ChildrenHeights.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_staggered_view/main.dart';

void main() {
  test('get lastIndex from ChildrenHeights', () {
    var childrenHeights = new ChildrenHeights(rowCount: 3, itemWidth: 100.0);

    ///没有添加任何元素的时候最大index为-1
    expect(childrenHeights.lastIndex, -1);

    ///添加一个元素，最大index为0
    childrenHeights.addChild(index: 0, width: 100.0, height: 50.0);
    expect(childrenHeights.lastIndex, 0);

    ///添加一个同index元素，再添加一个小index元素，最大index仍然为0
    childrenHeights.addChild(index: 0, width: 100.0, height: 50.0);
    childrenHeights.addChild(index: -1, width: 100.0, height: 50.0);
    expect(childrenHeights.lastIndex, 0);

    ///再添加一个元素，此时应该添加在第二竖排
    childrenHeights.addChild(index: 1, width: 100.0, height: 100.0);
    expect(childrenHeights.list[1].length, 1);
    childrenHeights.addChild(index: 2, width: 100.0, height: 70.0);

    ///增加第四个元素，此时应该追加到第一竖排
    childrenHeights.addChild(index: 3, width: 100.0, height: 70.0);
    expect(childrenHeights.list[0].length, 2);

    childrenHeights.addChild(index: 4, width: 100.0, height: 30.0);
    childrenHeights.addChild(index: 5, width: 100.0, height: 50.0);

/*    childrenHeights.list.forEach((hs) {
      print('-------------------------------------------');
      hs.forEach((h) {
        print('${h.index}, ${h.top}, ${h.bottom}');
      });
      print('-------------------------------------------');
    });*/
  });

/*  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(new MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });*/
}
