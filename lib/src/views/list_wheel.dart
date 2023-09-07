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
            diameterRatio: 2.0,
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
                      ? () => showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return GridViewSelector(
                                picker: picker,
                                onSelection: onSelection,
                              );
                            },
                          )
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
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.secondary),
                  ),
                );
              }).toList()
            ])),
      ),
    );
  }
}

class GridViewSelector extends ConsumerWidget {
  final XXPicker picker;
  final Function(int index)? onSelection;
  const GridViewSelector({
    super.key,
    required this.picker,
    this.onSelection,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Card(
          shadowColor: Theme.of(context).colorScheme.secondaryContainer,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceAround,
                  spacing: 2.0,
                  runSpacing: 4.0,
                  children: [
                    for (var i = 0; i < picker.items.length; i++)
                      Theme(
                        data: Theme.of(context).copyWith(
                          chipTheme: ChipThemeData(
                            backgroundColor: Colors
                                .transparent, // Set background color to be transparent
                            disabledColor: Colors
                                .transparent, // Set disabled color to be transparent
                            selectedColor: Colors
                                .transparent, // Set selected color to be transparent
                            secondaryLabelStyle: const TextStyle(
                                color: Colors.black), // Set label color
                            labelStyle: const TextStyle(
                                color: Colors.black), // Set label color
                            shape: RoundedRectangleBorder(
                              side: BorderSide.none,
                              // Define the shape
                              borderRadius: BorderRadius.circular(
                                  0), // Set border radius to 0 for no border
                            ),
                          ),
                        ),
                        child: ActionChip(
                          onPressed: () {
                            onSelection?.call(i);
                            Navigator.pop(context, true);
                          },
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          shape: const StadiumBorder(side: BorderSide.none),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          label: Text(
                            picker.labels[i],
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold),
                          ),
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text("Cancel")),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
