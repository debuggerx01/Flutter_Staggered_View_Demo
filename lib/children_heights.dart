import 'dart:math' show max;

import 'package:flutter/foundation.dart';

typedef int FindHeightTarget(Height height);

class Height {
  final double top;
  final double bottom;
  final int index;

  const Height(this.index, this.top, this.bottom);

  get mainAxisExtent => bottom - top;

  @override
  String toString() => 'Height : [index : $index , top : $top , bottom : $bottom]';
}

@immutable
class HeightWithRowIndex {
  final int rowIndex;
  final Height height;

  HeightWithRowIndex(this.rowIndex, this.height);
}

/// 单例容器，存放所有子布局的上下偏移于对应列标的列表中
class ChildrenHeights {
  static final ChildrenHeights _singleton = new ChildrenHeights._internal();

  double viewportHeight;

  int itemCount;

  /// 私有构造
  ChildrenHeights._internal();

  /// 单个子布局拉伸后的宽度
  double itemWidth;

  /// 子布局信息容器
  List<List<Height>> list;

  /// 第一次初始化必须传所有值，后面使用时必须不传值
  factory ChildrenHeights({int rowCount = 0, double itemWidth, double viewportHeight, int itemCount}) {
    /// 容器list为null时必为第一次初始化，设置各个初始化值
    if (_singleton.list == null) {
      _singleton.list = new List.generate(rowCount, (index) => new List<Height>());
      ;
      _singleton.itemWidth = itemWidth;
      _singleton.viewportHeight = viewportHeight;
      _singleton.itemCount = itemCount;
      return _singleton;
    }

    if (rowCount != 0) {
      /// 有值变化，根据情况修改调整容器内的信息
      if (rowCount != _singleton.list.length) {
        _singleton.rebuildList(rowCount, itemWidth);
      }
    }

    return _singleton;
  }

  /// 获取容器中最后一个布局信息的index
  int get lastIndex {
    int index = -1;
    for (var row in list) {
      var last = row.isEmpty ? -1 : row.last.index;
      index = max(index, last);
    }
    return index;
  }

  /// 获取容器中子布局信息的总数
  int get childCount {
    int count = 0;
    for (var row in list) {
      count += row.length;
    }
    return count;
  }

  int getMinIndexForScrollOffset(double scrollOffset) {
    return 0;
  }

  int getMaxIndexForScrollOffset(double scrollOffset) {
    print('itemCount : $itemCount');
    return 100;
  }

  /// 向容器中新增子布局，传入index以及对应的真实宽高
  void addChild({int index, double width, double height}) {
    double radio = height / width;
    double showHeight = itemWidth * radio;

    double minBottom = list[0].isEmpty ? 0.0 : list[0].last.bottom;
    int minRowIndex = 0;
    for (var rowIndex = 0; rowIndex < list.length; rowIndex++) {
      var row = list[rowIndex];
      if (row.isEmpty) {
        minBottom = 0.0;
        minRowIndex = rowIndex;
        break;
      }

      /// 如果已经存在比传入index更大index的子布局则直接返回
      if (row.last.index >= index) {
        return;
      }
      if (row.last.bottom < minBottom) {
        minBottom = row.last.bottom;
        minRowIndex = rowIndex;
      }
    }
    list[minRowIndex].add(new Height(index, minBottom, minBottom + showHeight));
  }

  ///可滑动的最大距离
  double computeMaxScrollOffset(int childCount) {
    if (list[0].isEmpty) return viewportHeight;
    double maxScrollOffset = list[0].last.bottom;
    for (var row in list) {
      if (row.isEmpty) {
        break;
      }
      maxScrollOffset = max(maxScrollOffset, row.last.bottom);
    }
    return maxScrollOffset;
  }

  HeightWithRowIndex getHeightByIndex(int index) {
    for (int rowIndex = 0; rowIndex < list.length; rowIndex++) {
      var res = _getHeightByIndexInRow(rowIndex, index);
      if (res != null) {
        return new HeightWithRowIndex(rowIndex, res);
      }
    }
    throw new Exception('can not getHeightByIndex : $index');
  }

  dynamic _getHeightByIndexInRow(int rowIndex, int index) {
    var row = list[rowIndex];
    if (row == null) return null;
    int left = 0;
    int right = row.length - 1;

    while (left <= right) {
      int mid = (left + right) ~/ 2;
      if (row[mid].index == index) {
        return row[mid];
      } else if (row[mid].index < index) {
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }
    return null;
  }

  /// 列数变化
  void rebuildList(int rowCount, double newItemWidth) {
    double oldItemWidth = itemWidth;
    itemWidth = newItemWidth;
    List<List<Height>> oldList = list;
    int last = lastIndex;
    list = new List<List<Height>>.generate(rowCount, (index) => new List<Height>());

    /// 每一列的处理指针集合
    List<int> pointers = new List.generate(oldList.length, (index) => 0);

    for (int index = 0; index <= last; index++) {
      for (int rowIndex = 0; rowIndex < oldList.length; rowIndex++) {
        if (oldList[rowIndex].length <= pointers[rowIndex]) {
          continue;
        }
        Height tempHeight = oldList[rowIndex][pointers[rowIndex]];
        if (tempHeight.index == index) {
          pointers[rowIndex] += 1;
          addChild(index: index, width: oldItemWidth, height: tempHeight.mainAxisExtent);
          break;
        }
      }
    }
  }
}
