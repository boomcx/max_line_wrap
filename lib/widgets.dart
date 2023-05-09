import 'dart:math';

import 'package:flutter/material.dart';

const colors = [
  Color(0xff1E75DB),
  Color(0xff4AB8FF),
  Color(0xffFD9331),
  Color(0xff4AB8FF),
  Color(0xffFFB93E),
  Color(0xff9C85DB),
  Color(0xffA0A5BA),
];

/// count 显示数量
/// isSpecial 是否要插入特殊的tag
List<Widget> getTagWidgets([int count = 10, bool isSpecial = false]) {
  final tags = getTags(count);
  return List.generate(tags.length, (index) {
    final i = colors.length > index ? index : index % colors.length;
    final color = colors[i];

    if (isSpecial && index == Random().nextInt(tags.length)) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000),
          color: color,
        ),
        child: Text(tags[index]),
      );
    }

    return TipsText(
      tags[index],
      textColor: color,
    );
  });
}

List<String> getTags([int count = 10]) {
  return List.generate(count, (index) {
    const text = '庆历四年春滕子京谪守巴陵郡越明年政通人和百废具兴乃重修岳阳楼增其旧制刻唐贤今人诗赋于其上属予作文以记之';
    final space = Random().nextInt(3) + 2;
    final posi = max(Random().nextInt(text.length) - space, 0);
    return text.substring(posi, posi + space);
  });
}

/// 文字标签
class TipsText extends StatelessWidget {
  const TipsText(
    this.text, {
    super.key,
    this.bgColor,
    this.textColor,
    this.borderColor,
  });

  final String text;
  final Color? bgColor;
  final Color? textColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final txtColor = textColor ?? const Color(0xffFD9331);
    final bgc = bgColor ?? txtColor.withOpacity(0.2);

    if (text.isEmpty) {
      return const SizedBox();
    }

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 5, vertical: borderColor != null ? 2 : 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
            color: borderColor ?? Colors.transparent,
            width: borderColor != null ? 0.5 : 0),
        color: bgc,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: txtColor,
        ),
      ),
    );
  }
}

class MoreArrow extends StatelessWidget {
  const MoreArrow({super.key, this.text, this.onPressed});

  final String? text;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // behavior: HitTestBehavior.translucent,
      onTap: onPressed,
      child: Container(
        color: Colors.red,
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Text(
          text ?? '更多>',
          style: const TextStyle(color: Colors.blueAccent, fontSize: 12),
        ),
      ),
    );
  }
}
