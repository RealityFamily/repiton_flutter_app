import 'package:flutter/material.dart';

class SeparatedList extends StatelessWidget {
  final List<Widget> children;
  final bool includeOuterSeparators;
  final MainAxisSize mainAxisSize;
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final IndexedWidgetBuilder separatorBuilder;

  const SeparatedList({
    Key? key,
    required this.children,
    this.includeOuterSeparators = false,
    this.mainAxisSize = MainAxisSize.max,
    this.direction = Axis.vertical,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    required this.separatorBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    final index = includeOuterSeparators ? 1 : 0;

    if (this.children.isNotEmpty) {
      if (includeOuterSeparators) {
        children.add(separatorBuilder(context, 0));
      }

      for (int i = 0; i < this.children.length; i++) {
        children.add(this.children[i]);

        if (this.children.length - i != 1) {
          children.add(separatorBuilder(context, i + index));
        }
      }

      if (includeOuterSeparators) {
        children.add(separatorBuilder(context, this.children.length));
      }
    }

    switch (direction) {
      case Axis.horizontal:
        return Row(
          key: key,
          children: children,
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
        );
      case Axis.vertical:
        return Column(
          key: key,
          children: children,
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
        );
    }
  }
}
