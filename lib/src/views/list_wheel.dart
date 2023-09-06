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
    required this.height,
    required this.width,
    this.focusColor,
    this.focusTextColor,
    this.onSelection,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        height: height * 5,
        width: width,
        child: ListWheelScrollView.useDelegate(
            overAndUnderCenterOpacity: 0.5,
            squeeze: 1.1,
            controller: picker.controller,
            itemExtent: height * 0.5,
            diameterRatio: 4.0,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (value) {
              if (picker.index != value) {
                onSelection?.call(value);
              }
            },
            childDelegate: ListWheelChildLoopingListDelegate(children: [
              ...picker.items.map((e) {
                final myIndex = picker.items.indexOf(e);
                final selected = myIndex == picker.index;
                return GestureDetector(
                  onTap: selected
                      ? null
                      : () {
                          onSelection?.call(myIndex);
                        },
                  child: CustCard(
                    label: picker.labels[myIndex],
                    height: height,
                    width: width,
                    alignment: Alignment.center,
                    backgroundColor: selected
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.secondaryContainer,
                    textStyle: TextStyle(
                        fontWeight: selected ? FontWeight.bold : null,
                        color: selected
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.secondary),
                  ),
                );
              }).toList()
            ])),
      ),
    );
  }
}

/**
 * 
 * (BuildContext context, int index) {
                final adjustedIndex = index % items.length;
                final selected = picker.index == adjustedIndex;

                return CustCard(
                  
                  label: picker.labels[index],
                  
                );
              })
 */
