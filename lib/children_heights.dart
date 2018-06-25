import 'dart:math' show max;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef int FindHeightTarget(Height height);

@immutable
class Height {
  final double top;
  final double bottom;
  final int index;
  final rowIndex;

  const Height(this.index, this.rowIndex, this.top, this.bottom);

  get mainAxisExtent => bottom - top;

  @override
  String toString() => 'Height : [index : $index , rowIndex : $rowIndex , top : $top , bottom : $bottom]';
}

/// 单例容器，用Map存放所有子布局的上下偏移于对应列标的列表中
class ChildrenHeights {
  /// 利用GlobalKey索引指定的容器实例
  static final Map<GlobalKey, ChildrenHeights> _singletons = {};
  double viewportHeight;

  int itemCount;

  /// 私有构造
  ChildrenHeights._internal();

  /// 单个子布局拉伸后的宽度
  double itemWidth;

  /// 子布局信息容器
  List<List<Height>> list;

  /// 原始子布局信息记录容器
  List<Height> _metaList = [];

  /// 初始化时传入包括GlobalKey在内的所有信息，由此创建实例并返回
  /// 后续功能中只传GlobalKey返回Map中的指定实例
  factory ChildrenHeights(GlobalKey key, {int rowCount = 0, double itemWidth, double viewportHeight, int itemCount}) {
    if (!_singletons.containsKey(key)) {
      _singletons[key] = ChildrenHeights._internal();
      _singletons[key].list = new List.generate(rowCount, (index) => new List<Height>());
      _singletons[key].itemWidth = itemWidth;
      _singletons[key].viewportHeight = viewportHeight;
      _singletons[key].itemCount = itemCount;
    }
    return _singletons[key];
  }

  /// 获取容器中最后一个布局信息的index
  int get lastIndex => _metaList.isEmpty ? -1 : _metaList.last.index;

  /// 获取容器中子布局信息的总数
  int get childCount => _metaList.isEmpty ? 0 : _metaList.length;

  int getMinIndexForScrollOffset(double scrollOffset) {
    return 0;
  }

  int getMaxIndexForScrollOffset(double scrollOffset) {
    print('itemCount : $itemCount');
    return 100;
  }

  /// 向容器中新增子布局，传入index以及对应的真实宽高
  /// 传入index必须是从0开始递增，出错将影响计算
  void addChild({int index, double width, double height}) {
    double radio = height / width;
    radio = radio.isNaN ? 0.0 : radio;
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
    var h = new Height(index, minRowIndex, minBottom, minBottom + showHeight);
    list[minRowIndex].add(h);
    _metaList.add(h);
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

  Height getHeightByIndex(int index) {
    if (_metaList[index] != null) return _metaList[index];
    throw new Exception('can not getHeightByIndex : $index');
  }

  /// 列数变化
  void rebuildList(int rowCount, double newItemWidth) {
    /// 临时保存列数变化前的子布局宽度后赋新值
    double oldItemWidth = itemWidth;
    itemWidth = newItemWidth;

    /// 临时提取所有子布局原始信息后清空两个容器
    List<Height> oldMetaList = _metaList;
    list = new List<List<Height>>.generate(rowCount, (index) => new List<Height>());
    _metaList = [];

    /// 循环执行添加操作，完成新列数下的布局信息计算存储
    oldMetaList.forEach((ch) {
      addChild(index: ch.index, width: oldItemWidth, height: ch.mainAxisExtent);
    });
  }

  /// 修改指定index子布局的信息
  void updateChild(int index, Size newSize) {
    /// 提取出指定index之后的所有子布局信息
    var leftList = _metaList.where((ele) => ele.index > index).toList();

    /// 从两个容器中移除包括指定index及其之后的子布局信息
    _metaList.removeWhere((ele) => ele.index >= index);
    list.forEach((row) {
      row.removeWhere((ele) => ele.index >= index);
    });

    /// 先添加指定的子布局
    addChild(index: index, width: newSize.width, height: newSize.height);

    /// 循环重新添加前面保存下来已经移除的子布局信息们
    leftList.forEach((height) {
      addChild(index: height.index, width: itemWidth, height: height.mainAxisExtent);
    });
  }
}
