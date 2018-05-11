import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_view/ChildrenHeights.dart';

class MySliverGridDelegate extends SliverGridDelegate {
  ChildrenHeights childrenHeights;
  int rowCount;
  double _itemWidth;

  double screenWidth;

  MySliverGridDelegate({@required this.rowCount, @required this.screenWidth, @required viewportHeight}) {
    _itemWidth = screenWidth / rowCount;
    childrenHeights = new ChildrenHeights(rowCount: rowCount, itemWidth: _itemWidth, viewportHeight: viewportHeight);
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
    return new SliverGridGeometry(crossAxisExtent: 0.0, crossAxisOffset: 0.0, mainAxisExtent: 0.0, scrollOffset: 0.0);
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
    return 0.0;
  }
}
