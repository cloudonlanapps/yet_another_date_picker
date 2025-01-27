import 'package:flutter/material.dart';

import 'ddmmyyyy.dart';
import 'model/date_picker.dart';
import 'model/picker.dart';

import 'themedata.dart';
import 'views/date_selector_view.dart';

class DateSelector extends StatelessWidget {
  final List<int> years;
  final DDMMYYYY date;

  final bool allowDisableDaySelection;
  final bool allowDisableYearSelection;
  final double width;
  final double height;
  final double? itemExtend;

  final DateSelectorThemeData? dateSelectorThemeData;
  final Future<void> Function(DDMMYYYY ddmmyyyy) onDateChanged;
  final void Function() onReset;

  const DateSelector({
    super.key,
    required this.years,
    required this.date,
    required this.onDateChanged,
    this.allowDisableDaySelection = true,
    this.allowDisableYearSelection = true,
    this.width = 252,
    this.height = 252,
    this.itemExtend,
    this.dateSelectorThemeData,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final DateSelectorThemeData defaultTheme = DateSelectorThemeData(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      backgroundColorDisabled: Theme.of(context).colorScheme.surface,
      backgroundColorSelected: Theme.of(context).colorScheme.primaryContainer,
      textStyle:
          TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
      textStyleDisabled:
          TextStyle(color: Theme.of(context).colorScheme.onSurface),
      textStyleSelected: TextStyle(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        fontWeight: FontWeight.bold,
      ),
      iconColor: Theme.of(context).colorScheme.primary,
    );
    final dateSelector = DateSelectorModel(
      years: years,
      initialValue: date,
      allowDisableDaySelection: allowDisableDaySelection,
      allowDisableYearSelection: allowDisableYearSelection,
    );
    return DateSelectorView(
      ddPicker: dateSelector.ddPicker,
      mmPicker: dateSelector.mmPicker,
      yyyyPicker: dateSelector.yyyyPicker,
      width: width,
      height: height,
      itemExtend: itemExtend ?? width / 6,
      theme: dateSelectorThemeData ?? defaultTheme,
      onSelection: ({required int index, required PickerID pickerID}) {
        onDateChanged(dateSelector.onChange(pickerID, index).ddmmyyyy);
      },
      onToggleDisable: ({required PickerID pickerID}) {
        onDateChanged(dateSelector.toggleDisable(pickerID).ddmmyyyy);
      },
      onReset: onReset,
    );
  }
}
