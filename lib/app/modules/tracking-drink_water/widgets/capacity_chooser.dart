import 'package:flutter/material.dart';

class CapacityChooser extends StatefulWidget {
  final int seletedIndex;
  final ValueChanged<int>? onSelectedIndexChange;
  final List<CapacityChooserItem> items;
  final double? iconSize;
  final double? itemSpacer;

  const CapacityChooser({
    Key? key,
    required this.seletedIndex,
    this.onSelectedIndexChange,
    required this.items,
    this.iconSize,
    this.itemSpacer,
  }) : super(key: key);

  @override
  State<CapacityChooser> createState() => _CapacityChooserState();
}

class _CapacityChooserState extends State<CapacityChooser> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < widget.items.length; i++) ...[
          _CapacityChooserItem(
            icon: i == widget.seletedIndex
                ? widget.items[i].seletedIcon
                : widget.items[i].icon,
            size: (widget.iconSize ?? 48) +
                (widget.iconSize ?? 48) * i / widget.items.length,
            onTap: () => widget.onSelectedIndexChange!(i),
          ),
          if (i != widget.items.length - 1)
            SizedBox(width: widget.itemSpacer ?? 24)
        ]
      ],
    );
  }
}

class _CapacityChooserItem extends StatelessWidget {
  final String icon;
  final double size;
  final void Function() onTap;

  const _CapacityChooserItem(
      {Key? key, required this.icon, required this.size, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(icon, width: size, height: size),
    );
  }
}

class CapacityChooserItem {
  String icon;
  String seletedIcon;
  String? extraIcon;
  int capacity;

  CapacityChooserItem({
    required this.icon,
    required this.seletedIcon,
    required this.capacity,
    this.extraIcon,
  });
}
