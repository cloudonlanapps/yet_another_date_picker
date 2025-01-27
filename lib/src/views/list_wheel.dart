import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../themedata.dart';
import '../model/picker.dart';
import 'grid_view.dart';
import 'item_view.dart';

class ListWheel extends ConsumerWidget {
  const ListWheel({
    super.key,
    required this.picker,
    required this.height,
    required this.width,
    required this.itemExtent,
    required this.onSelection,
    required this.theme,
  });

  final Selector picker;
  final double height;
  final double width;
  final double itemExtent;

  final void Function({required PickerID pickerID, required int index})
      onSelection;
  final DateSelectorThemeData theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: SizedBox(
        height: height,
        width: width,
        child: ListWheelScrollView.useDelegate(
            overAndUnderCenterOpacity: 0.5,
            controller: picker.controller,
            itemExtent: itemExtent,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (value) {
              if (picker.index != value) {
                onSelection.call(pickerID: picker.pickerID, index: value);
              }
            },
            childDelegate: ListWheelChildLoopingListDelegate(children: [
              ...picker.items.map((e) {
                final myIndex = picker.items.indexOf(e);
                final selected = myIndex == picker.index;
                final Color backgroundColor = theme.backgroundColor;

                final TextStyle textStyle =
                    selected ? theme.textStyleSelected : theme.textStyle;
                return GestureDetector(
                  onTap: selected
                      ? () => showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return GridViewSelector(
                                picker: picker,
                                theme: theme,
                                onSelection: (value) {
                                  if (picker.index != value) {
                                    onSelection.call(
                                        pickerID: picker.pickerID,
                                        index: value);
                                  }
                                },
                              );
                            },
                          )
                      : () {
                          onSelection.call(
                              pickerID: picker.pickerID, index: myIndex);
                        },
                  child: ItemView(
                    backgroundColor: backgroundColor,
                    textStyle: textStyle,
                    label: picker.labels[myIndex],
                  ),
                );
              }).toList()
            ])),
      ),
    );
  }
}
