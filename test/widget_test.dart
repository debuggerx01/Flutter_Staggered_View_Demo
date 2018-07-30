// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter/material.dart';
import 'package:flutter_staggered_view/children_heights.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('get lastIndex from ChildrenHeights', () {
    var key = GlobalKey();
    var chs = new ChildrenHeights(key, rowCount: 3, itemWidth: 100.0);

    /// 初始化容器长度为10个单位
    chs.fillList(10);

    /// 更新第一个元素
    chs.updateChild(0, Size(100.0, 50.0));

    /// 更新第二个元素，此时应该添加在第二竖排
    chs.updateChild(1, Size(100.0, 100.0));
    expect(chs.list[1].length, 1);
    chs.updateChild(2, 100.0, 70.0);

    ///增加第四个元素，此时应该追加到第一竖排
    chs.updateChild(3, 100.0, 70.0);
    expect(chs.list[0].length, 2);

    chs.updateChild(4, 100.0, 30.0);
    chs.updateChild(5, 100.0, 50.0);

    ///测试通过index获取元素
    expect(chs.getHeightByIndex(3).bottom, 120);
    expect(chs.getHeightByIndex(3).rowIndex, 0);
    expect(chs.getHeightByIndex(4).top, 70);
    expect(chs.getHeightByIndex(4).rowIndex, 2);

    printHeights(chs);

    chs.rebuildList(2, 150.0);
    print('#################################');
    printHeights(chs);

    chs.updateChild(4, Size(100.0, 300.0));
    print('#################################');
    printHeights(chs);

    expect(chs.getHeightByIndex(5).rowIndex, 1);
  });
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
