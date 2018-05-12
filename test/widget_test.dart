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
    var chs = new ChildrenHeights(rowCount: 3, itemWidth: 100.0);

    ///没有添加任何元素的时候最大index为-1
    expect(chs.lastIndex, -1);

    ///添加一个元素，最大index为0
    chs.addChild(index: 0, width: 100.0, height: 50.0);
    expect(chs.lastIndex, 0);

    ///添加一个同index元素，再添加一个小index元素，最大index仍然为0
    chs.addChild(index: 0, width: 100.0, height: 50.0);
    chs.addChild(index: -1, width: 100.0, height: 50.0);
    expect(chs.lastIndex, 0);

    ///再添加一个元素，此时应该添加在第二竖排
    chs.addChild(index: 1, width: 100.0, height: 100.0);
    expect(chs.list[1].length, 1);
    chs.addChild(index: 2, width: 100.0, height: 70.0);

    ///增加第四个元素，此时应该追加到第一竖排
    chs.addChild(index: 3, width: 100.0, height: 70.0);
    expect(chs.list[0].length, 2);

    chs.addChild(index: 4, width: 100.0, height: 30.0);
    chs.addChild(index: 5, width: 100.0, height: 50.0);

    ///测试通过index获取元素
    expect(chs.getHeightByIndex(3).height.bottom, 120);
    expect(chs.getHeightByIndex(3).rowIndex, 0);
    expect(chs.getHeightByIndex(4).height.top, 70);
    expect(chs.getHeightByIndex(4).rowIndex, 2);

    printHeights(chs);

    chs.rebuildList(2, 150.0);
    print('#################################');

    printHeights(chs);
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

void printHeights(chs) {
  chs.list.forEach((hs) {
    print('-------------------------------------------');
    hs.forEach((h) {
      print('${h.index}, ${h.top}, ${h.bottom}');
    });
    print('-------------------------------------------');
  });
}
