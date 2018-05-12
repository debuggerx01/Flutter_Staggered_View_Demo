import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_view/ChildrenHeights.dart';

class MySliverGridDelegate extends SliverGridDelegate {
  ChildrenHeights childrenHeights;
  int rowCount;
  double _itemWidth;

  double screenWidth;

  MySliverGridDelegate(
      {@required this.rowCount, @required this.screenWidth, @required viewportHeight, @required itemCount}) {
    _itemWidth = screenWidth / rowCount;
    childrenHeights = new ChildrenHeights(
        rowCount: rowCount, itemWidth: _itemWidth, viewportHeight: viewportHeight, itemCount: itemCount);
  }

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    return new MySliverGridLayout();
  }

  @override
  bool shouldRelayout(SliverGridDelegate oldDelegate) {
    return oldDelegate != this;
  }
}

@immutable
class MySliverGridLayout extends SliverGridLayout {
  final ChildrenHeights ch;

  MySliverGridLayout() : ch = new ChildrenHeights();

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    // TODO: implement getGeometryForChildIndex

    var chs = new ChildrenHeights();

    ///该子布局第一次加载时，容器中无信息，此时直接返回全屏渲染以供计算
    if (index > chs.lastIndex)
      return new SliverGridGeometry(
          crossAxisExtent: ch.itemWidth * ch.list.length,
          crossAxisOffset: 0.0,
          mainAxisExtent: ch.viewportHeight,
          scrollOffset: ch.viewportHeight * index);

    ///如果容器中已有信息，取出后生成指定的几何信息
    var heightWithRowIndex = chs.getHeightByIndex(index);
    return new SliverGridGeometry(
        crossAxisExtent: ch.itemWidth,
        crossAxisOffset: ch.itemWidth * heightWithRowIndex.rowIndex,
        mainAxisExtent: heightWithRowIndex.height.mainAxisExtent,
        scrollOffset: heightWithRowIndex.height.top);
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    // TODO: implement getMaxChildIndexForScrollOffset
    return ch.getMaxIndexForScrollOffset(scrollOffset);
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    // TODO: implement getMinChildIndexForScrollOffset
    return ch.getMinIndexForScrollOffset(scrollOffset);
  }

  @override
  double computeMaxScrollOffset(int childCount) {
    // TODO: implement computeMaxScrollOffset
    return ch.computeMaxScrollOffset(childCount);
  }
}
