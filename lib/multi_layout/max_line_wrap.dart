import 'package:flutter/material.dart';

import 'size_multi_child_layout.dart';

const _kMoreTag = 'more';

class MaxLineWrap extends StatefulWidget {
  final List<Widget> children;
  final int maxLine;
  final double spacing;
  final double runSpacing;
  final Widget? more;
  final MaxLineWrapAlignment itemAlignment;

  const MaxLineWrap({
    super.key,
    required this.children,
    this.maxLine = -1,
    this.runSpacing = 8.0,
    this.spacing = 8.0,
    this.more,
    this.itemAlignment = MaxLineWrapAlignment.end,
  });

  @override
  State<MaxLineWrap> createState() => _MaxLineWrapState();
}

///state实现类
class _MaxLineWrapState extends State<MaxLineWrap> {
  List<Object> idList = [];

  @override
  void initState() {
    super.initState();

    idList = List.generate(widget.children.length, (index) => '$index');
    if (widget.more != null) {
      idList.add(_kMoreTag);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomSizedMultiChildLayout(
      delegate: _MaxLineWrapDelegate(
        idList,
        widget.maxLine,
        widget.spacing,
        widget.runSpacing,
        widget.more,
        widget.itemAlignment,
      ),
      children: List.generate(idList.length, (index) {
        var child = (widget.more != null && index == idList.length - 1)
            ? widget.more!
            : widget.children[index];
        return LayoutId(
          id: idList[index],
          child: child,
        );
      }),
    );
  }
}

/// 通过 `Axis.horizontal` `Axis.vertical`来区分每个视图的靠齐方式
/// 目前仅支持 `Axis.horizontal`
enum MaxLineWrapAlignment {
  /// 每行排列方式向上/向左靠齐
  start,

  /// 居中
  center,

  /// 每行排列方式向下/向右靠齐
  end,
}

class _MaxLineWrapDelegate extends SizedMultiChildLayoutDelegate {
  final List<Object> idList;
  final int maxLine;
  final double spacing;
  final double runSpacing;
  final Widget? more;
  final MaxLineWrapAlignment itemAlignment;

  _MaxLineWrapDelegate(
    this.idList,
    this.maxLine,
    this.spacing,
    this.runSpacing,
    this.more,
    this.itemAlignment,
  );

  @override
  Size performLayout(Size size) {
    final groups = resetContainer(size);

    double offsetY = 0;
    double boxHeight = 0;

    for (var line in groups.keys) {
      final group = groups[line]!;

      // 获取当前行最高的元素
      double maxHeight = 0;
      for (var child in group) {
        final size = child['size'] as Size;
        if (maxHeight < size.height) {
          maxHeight = size.height;
        }
      }

      // 渲染元素
      double lineX = 0;
      for (var child in group) {
        final id = child['id'];
        final itemSize = child['size'] as Size;
        final show = child['show'];

        double lineY = 0;
        switch (itemAlignment) {
          case MaxLineWrapAlignment.center:
            lineY = (maxHeight - itemSize.height) / 2;
            break;
          case MaxLineWrapAlignment.end:
            lineY = maxHeight - itemSize.height;
            break;
          default:
            lineY = 0;
        }

        if (id == _kMoreTag) {
          if (show == true) {
            positionChild(
                id,
                Offset(size.width - itemSize.width,
                    offsetY + (maxHeight - itemSize.height)));
            continue;
          }
        } else {
          if (show == true) {
            positionChild(id, Offset(lineX, offsetY + lineY));
            lineX += itemSize.width + spacing;
            continue;
          }
        }
        hideChild(id);
      }

      offsetY += (maxHeight + runSpacing);

      if (int.parse(line) <= maxLine || maxLine < 0) {
        boxHeight += (maxHeight + runSpacing);
      }
    }

    return Size(size.width, boxHeight);
  }

  /// 组装每个子项的信息
  /// 按每行记录每个子视图的位置信息、是否需要显示
  /// 由于每个子项宽高不一，如果直接排列可能会出现子项重叠的情况
  /// 按每行一个集合，取出其中最高项为计算坐标依据（即可实现排列方式 `MaxLineWrapAlignment`）
  Map<String, List<Map<String, dynamic>>> resetContainer(Size size) {
    /// ```
    ///   {...
    ///    line number : [{
    ///       id: child id,
    ///       size: child size,
    ///       show: show or not
    ///     }], ...}
    /// ```
    final groups = <String, List<Map<String, dynamic>>>{};

    double x = 0.0;
    int line = 1;
    bool isShowChild = true;
    bool isHideMore = false;
    final hasMore = idList.last == _kMoreTag;
    Size moreSize = Size.zero;
    if (hasMore) {
      moreSize = layoutChild(idList.last, BoxConstraints(maxWidth: size.width));
    }

    for (var i = 0; i < idList.length; i++) {
      var element = idList[i];

      if (element == _kMoreTag) {
        if (!isHideMore) {
          final item = {
            'id': element,
            'size': moreSize,
            'show': false,
          };
          if (groups['$line'] is List) {
            groups['$line']?.add(item);
          } else {
            groups['$line'] = [item];
          }
        }
      } else if (hasChild(element)) {
        Size viewSize =
            layoutChild(element, BoxConstraints(maxWidth: size.width));

        if (line == maxLine) {
          // 设置行数与显示行数相等，判断追加视图是否显示
          if (x + viewSize.width + spacing + moreSize.width >= size.width) {
            isShowChild = false;
            isHideMore = true;
            // 插入拼接子项
            final item = {
              'id': _kMoreTag,
              'size': moreSize,
              'show': true,
            };
            if (groups['$line'] is List) {
              groups['$line']?.add(item);
            } else {
              groups['$line'] = [item];
            }
            // 换行（这里换行是为了容错最高item不在显示行中，导致计算错误）
            line += 1;
            x = 0;
          }
        } else {
          // 当前行是否超出显示，换行
          if (x + viewSize.width > size.width) {
            line += 1;
            x = 0;
          }
        }

        final item = {
          'id': element,
          'size': viewSize,
          'show': isShowChild,
        };

        if (groups['$line'] is List) {
          groups['$line']?.add(item);
        } else {
          groups['$line'] = [item];
        }

        x += viewSize.width + spacing;
      }
    }
    return groups;
  }

  void hideChild(Object childId) {
    positionChild(childId, const Offset(-10000, -10000));
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}
