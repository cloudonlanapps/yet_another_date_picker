// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import '../model/picker.dart';

import '../themedata.dart';
import 'list_wheel.dart';

class PickerView extends StatelessWidget {
  const PickerView(
      {super.key,
      required this.picker,
      required this.height,
      required this.width,
      required this.itemExtent,
      required this.bottomPadding,
      required this.theme,
      required this.onSelection});

  final Selector picker;
  final double height;
  final double width;
  final double itemExtent;

  final double bottomPadding;
  final DateSelectorThemeData theme;

  final void Function({required int index, required PickerID pickerID})
      onSelection;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      picker.scrollTo();
    });
    print(picker);
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Stack(
        children: [
          ListWheel(
            picker: picker,
            width: width,
            height: height,
            itemExtent: itemExtent,
            onSelection: onSelection,
            theme: theme,
          ),
          if (picker.isDisabled)
            SizedBox(
              height: height,
              width: width,
              child: Container(
                color: theme.backgroundColor,
                alignment: Alignment.center,
                child: RotatedBox(
                    quarterTurns: -1,
                    child: Text(
                      "Any ${picker.pickerID == PickerID.ddPicker ? "Day" : "Year"}",
                      style: theme.textStyleSelected,
                    )),
              ),
            ),
        ],
      ),
    );
  }
}
