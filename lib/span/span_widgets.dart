import 'package:flutter/material.dart';
import 'package:max_line_wrap/widgets.dart';

class SpanWidgets extends StatelessWidget {
  const SpanWidgets({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '''
通过`RichText`构建多行标签可以通过`maxLines`控制最大显示行数，
但是没办法在尾部良好的拼接扩展按钮（更多、展开等只能紧紧跟随最后一个内容标签，而不是显示在右侧尾部）,但如果要控制最大显示行就没办法插入显示`扩展按钮`。
该方法仅限于需要控制显示行数，无其他逻辑操作使用（列表标签）
''',
              strutStyle: StrutStyle(height: 1.4),
            ),
            RichText(
              text: TextSpan(children: [
                ...getTagWidgets(33, true)
                    .map((e) => WidgetSpan(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 6, top: 6),
                          child: e,
                        )))
                    .toList(),
                const WidgetSpan(child: MoreArrow()),
              ]),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            const Text(
              '''
通过`Wrap`构建多行标签最为简单，可以简单高效的使用横纵间隙或者排列展示方式，但是没办法控制最大显示行数，
亦不更控制显示扩展按钮（只能紧紧跟随最后一个内容标签，而不是显示在右侧尾部）
''',
              strutStyle: StrutStyle(height: 1.4),
            ),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                ...getTagWidgets(12, true).map((e) => e).toList(),
                const MoreArrow(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
