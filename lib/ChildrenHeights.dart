import 'dart:math' show max;

class Height {
  final double top;
  final double bottom;
  final int index;

  const Height(this.index, this.top, this.bottom);
}

/// 单例容器，存放所有子布局的上下偏移于对应列标的列表中
class ChildrenHeights {
  static final ChildrenHeights _singleton = new ChildrenHeights._internal();

  double viewportHeight;

  /// 私有构造
  ChildrenHeights._internal();

  /// 单个子布局拉伸后的宽度
  double itemWidth;

  /// 子布局信息容器
  List<List<Height>> list;

  /// 第一次初始化必须传rowCount和itemWidth两个值，后面使用时必须不传值
  factory ChildrenHeights({int rowCount = 0, double itemWidth, double viewportHeight}) {
    if (rowCount != 0) {
      _singleton.list = new List(rowCount);
      _singleton.itemWidth = itemWidth;
      _singleton.viewportHeight = viewportHeight;
      for (int i = 0; i < rowCount; i++) {
        _singleton.list[i] = new List<Height>();
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
    return 0;
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
}
