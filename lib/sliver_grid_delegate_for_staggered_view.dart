import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_view/children_heights.dart';

class SliverGridDelegateForStaggeredView extends SliverGridDelegate {
  /// 利用key可以从ChildrenHeights单例中获取对应的信息容器
  GlobalKey key;

  SliverGridDelegateForStaggeredView({@required this.key});

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    return new SliverGridLayoutForStaggeredView(key: key);
  }

  @override
  bool shouldRelayout(SliverGridDelegate oldDelegate) {
    return oldDelegate != this;
  }
}

@immutable
class SliverGridLayoutForStaggeredView extends SliverGridLayout {
  final GlobalKey key;

  SliverGridLayoutForStaggeredView({@required this.key});

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    var chs = ChildrenHeights(key);
    var height = chs.getHeightByIndex(index);

    /// 该子布局第一次加载时，其高度为0.0，此时直接返回全屏渲染以供计算
    if (height.mainAxisExtent == 0.0)
      return new SliverGridGeometry(
          crossAxisExtent: chs.itemWidth * chs.list.length,
          crossAxisOffset: chs.itemWidth * chs.list.length,
          mainAxisExtent: chs.viewportHeight,
          scrollOffset: 0.0);

    ///如果容器中子布局信息已经为有效值，取出后生成指定的几何信息
    return new SliverGridGeometry(
        crossAxisExtent: chs.itemWidth,
        crossAxisOffset: chs.itemWidth * height.rowIndex,
        mainAxisExtent: height.mainAxisExtent,
        scrollOffset: height.top);
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    return ChildrenHeights(key).getMaxIndexForScrollOffset(scrollOffset);
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    return ChildrenHeights(key).getMinIndexForScrollOffset(scrollOffset);
  }

  @override
  double computeMaxScrollOffset(int childCount) {
    return ChildrenHeights(key).computeMaxScrollOffset(childCount);
  }
}
