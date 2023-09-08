// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yet_another_date_picker/src/themedata.dart';

import '../model/picker.dart';
import '../provider/date_picker.dart';

class PickerActivator extends ConsumerWidget {
  const PickerActivator({
    super.key,
    required this.pickerID,
    required this.theme,
  });

  final PickerID pickerID;
  final DateSelectorThemeData theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final XXPicker picker = ref.watch(
        datePickerNotifierProvider.select((value) => value.pickers[pickerID]!));
    return Tooltip(
      message:
          "${picker.isDisabled ? "Select" : "Ignore"} ${picker.pickerID == PickerID.datePicker ? "Day" : "Year"}",
      child: GestureDetector(
        onTap: () {
          ref
              .read(datePickerNotifierProvider.notifier)
              .toggleDisable(pickerID: picker.pickerID);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          alignment: Alignment.center,
          /*   decoration:
              BoxDecoration(border: Border.all(width: 0.25)), */
          child: Icon(
            picker.isDisabled ? Icons.toggle_off : Icons.toggle_on,
            color: theme.iconColor,
            size: 24,
          ),
        ),
      ),
    );
  }
}
