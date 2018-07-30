import 'package:flutter/material.dart';
import 'package:flutter_staggered_view/children_heights.dart';

class ScrollControllerForStaggeredView extends ScrollController {
  ChildrenHeights chs;
  GlobalKey key;

  ScrollControllerForStaggeredView(
    this.key, {
    double initialScrollOffset: 0.0,
    keepScrollOffset: true,
    debugLabel,

    /// chs初始化相关参数
    int rowCount,
    double screenWidth,
    double viewportHeight,
    int itemCount,
  })  : chs = new ChildrenHeights(key,
            rowCount: rowCount,
            itemWidth: screenWidth / rowCount,
            viewportHeight: viewportHeight,
            itemCount: itemCount),
        super(initialScrollOffset: initialScrollOffset, keepScrollOffset: keepScrollOffset, debugLabel: debugLabel);
}
