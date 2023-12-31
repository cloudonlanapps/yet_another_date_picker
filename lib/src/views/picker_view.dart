// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/picker.dart';
import '../provider/date_picker.dart';
import '../themedata.dart';
import 'list_wheel.dart';

class PickerView extends ConsumerWidget {
  const PickerView({
    super.key,
    required this.pickerID,
    required this.height,
    required this.width,
    required this.itemExtent,
    required this.bottomPadding,
    required this.theme,
    required this.allowDisable,
  });

  final PickerID pickerID;
  final double height;
  final double width;
  final double itemExtent;

  final double bottomPadding;
  final DateSelectorThemeData theme;
  final bool allowDisable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Selector picker = ref.watch(
        datePickerNotifierProvider.select((value) => value.pickers[pickerID]!));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      picker.scrollTo();
    });

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Stack(
        children: [
          ListWheel(
            picker: picker,
            width: width,
            height: height,
            itemExtent: itemExtent,
            onSelection: ref.read(datePickerNotifierProvider.notifier).onChange,
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
                      "Any ${picker.pickerID == PickerID.datePicker ? "Day" : "Year"}",
                      style: theme.textStyleSelected,
                    )),
              ),
            ),
        ],
      ),
    );
  }
}
