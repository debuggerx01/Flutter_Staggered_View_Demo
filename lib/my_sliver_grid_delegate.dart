import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_view/children_heights.dart';

class MySliverGridDelegate extends SliverGridDelegate {
  GlobalKey key;

  MySliverGridDelegate({@required this.key});

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    return new MySliverGridLayout(key: key);
  }

  @override
  bool shouldRelayout(SliverGridDelegate oldDelegate) {
    return oldDelegate != this;
  }
}

@immutable
class MySliverGridLayout extends SliverGridLayout {
  final GlobalKey key;

  MySliverGridLayout({@required this.key});

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    // TODO: implement getGeometryForChildIndex

    var chs = ChildrenHeights(key);

    ///该子布局第一次加载时，容器中无信息，此时直接返回全屏渲染以供计算
    if (index > chs.lastIndex)
      return new SliverGridGeometry(
          crossAxisExtent: chs.itemWidth * chs.list.length,
          crossAxisOffset: chs.itemWidth * chs.list.length,
          mainAxisExtent: chs.viewportHeight,
          scrollOffset: chs.viewportHeight * index);

    ///如果容器中已有信息，取出后生成指定的几何信息
    var height = chs.getHeightByIndex(index);
    return new SliverGridGeometry(
        crossAxisExtent: chs.itemWidth,
        crossAxisOffset: chs.itemWidth * height.rowIndex,
        mainAxisExtent: height.mainAxisExtent,
        scrollOffset: height.top);
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    // TODO: implement getMaxChildIndexForScrollOffset
    return ChildrenHeights(key).getMaxIndexForScrollOffset(scrollOffset);
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    // TODO: implement getMinChildIndexForScrollOffset
    return ChildrenHeights(key).getMinIndexForScrollOffset(scrollOffset);
  }

  @override
  double computeMaxScrollOffset(int childCount) {
    // TODO: implement computeMaxScrollOffset
    return ChildrenHeights(key).computeMaxScrollOffset(childCount);
  }
}
