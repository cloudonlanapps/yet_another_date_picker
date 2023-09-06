import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/picker.dart';
import 'item_view.dart';

class ListWheel extends ConsumerWidget {
  final XXPicker picker;
  final double height;
  final double width;
  final Color? focusColor;
  final Color? focusTextColor;
  final Function(int index)? onSelection;
  const ListWheel({
    super.key,
    required this.picker,
    this.height = kMinInteractiveDimension * 2,
    this.width = kMinInteractiveDimension,
    this.focusColor,
    this.focusTextColor,
    this.onSelection,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = picker.labels;

    return Center(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        height: height,
        width: width,
        child: ListWheelScrollView.useDelegate(
          overAndUnderCenterOpacity: 0.5,
          squeeze: 1.1,
          controller: picker.controller,
          itemExtent: height * 0.5,
          diameterRatio: 2.0,
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: (value) {
            final absoluteValue = value % items.length;
            picker.controller.jumpToItem(absoluteValue + items.length);
            if (picker.index != absoluteValue) {
              onSelection?.call(value % items.length);
            }
          },
          childDelegate: ListWheelChildBuilderDelegate(
              childCount: items.length * 3, // Create extra items for looping
              builder: (BuildContext context, int index) {
                final adjustedIndex = index % items.length;
                final selected = picker.index == adjustedIndex;

                return CustCard(
                  height: height,
                  width: width,
                  label: picker.labels3[index],
                  alignment: Alignment.center,
                  backgroundColor: selected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.secondaryContainer,
                  textStyle: TextStyle(
                      fontWeight: selected ? FontWeight.bold : null,
                      color: selected
                          ? Theme.of(context).colorScheme.error
                          : null),
                );
              }),
        ),
      ),
    );
  }
}
