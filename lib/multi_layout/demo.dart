import 'package:flutter/material.dart';
import 'package:max_line_wrap/multi_layout/max_line_wrap.dart';
import 'package:max_line_wrap/widgets.dart';

class MaxLineWrapDemo extends StatelessWidget {
  const MaxLineWrapDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final children = getTagWidgets(30, true).map((e) => e).toList();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '''
通过`MaxLineWrap` `maxLine=2`
''',
              strutStyle: StrutStyle(height: 1.4),
            ),
            MaxLineWrap(
              maxLine: 2,
              more: const MoreArrow(),
              children: children,
            ),
            const SizedBox(height: 20),
            const Text(
              '''
通过`MaxLineWrap` `maxLine=1`
''',
              strutStyle: StrutStyle(height: 1.4),
            ),
            MaxLineWrap(
              maxLine: 1,
              more: const MoreArrow(),
              children: children,
            ),
            const SizedBox(height: 20),
            const Text(
              '''
通过`MaxLineWrap` `maxLine=-1` 显示全部
''',
              strutStyle: StrutStyle(height: 1.4),
            ),
            ColoredBox(
              color: Colors.black12,
              child: MaxLineWrap(
                more: const MoreArrow(),
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
