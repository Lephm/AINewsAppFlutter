import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class FadeAnimationWrapper extends StatelessWidget {
  const FadeAnimationWrapper({
    super.key,
    required this.child,
    required this.index,
    this.delayedPerItem = 150,
    this.duration = 400,
  });

  final Widget child;
  final int index;
  final int delayedPerItem;
  final int duration;

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      from: 30,
      delay: Duration(milliseconds: index * delayedPerItem),
      duration: Duration(milliseconds: duration),
      child: child,
    );
  }
}
