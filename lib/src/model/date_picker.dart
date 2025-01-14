// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../ddmmyyyy.dart';
import 'picker.dart';
import 'year.dart';

@immutable
class DateSelectorModel {
  final Selector<int> ddPicker;
  final Selector<String> mmPicker;
  final Selector<Year> yyyyPicker;

  final DDMMYYYY initialValue;
  final bool allowDisableDaySelection;
  final bool allowDisableYearSelection;

  const DateSelectorModel._({
    required this.ddPicker,
    required this.mmPicker,
    required this.yyyyPicker,
    required this.initialValue,
    required this.allowDisableDaySelection,
    required this.allowDisableYearSelection,
  });

  factory DateSelectorModel({
    required List<int> years,
    required DDMMYYYY initialValue,
    required bool allowDisableDaySelection,
    required bool allowDisableYearSelection,
  }) {
    if (initialValue.dd == null && initialValue.yyyy == null) {
      throw Exception("Both day and year can't be null");
    }
    final List<Year> yearsSorted = [
      ...years.map((e) => Year(e)).toList()
        ..sort((a, b) => a.value.compareTo(b.value)),
    ];

    final int dd = (initialValue.dd == null) ? 0 : initialValue.dd!;
    final int mm = initialValue.mm; // Indexed from 0
    final int yy = yearsSorted.getIndexOfByInt(initialValue.yyyy) ??
        yearsSorted.length - 1;

    final List<int> days = daysInMonth(yearsSorted, yearsSorted[yy], mm);

    return DateSelectorModel._(
        ddPicker: Selector<int>(
            pickerID: PickerID.ddPicker,
            index: dd - 1,
            items: days,
            isDisabled: initialValue.dd == null),
        mmPicker: Selector<String>(
            pickerID: PickerID.mmPicker, index: mm, items: monthsOfTheYear),
        yyyyPicker: Selector<Year>(
            pickerID: PickerID.yyyyPicker,
            index: yy,
            items: yearsSorted,
            isDisabled: initialValue.yyyy == null),
        allowDisableDaySelection: allowDisableDaySelection,
        allowDisableYearSelection: allowDisableYearSelection,
        initialValue: initialValue);
  }
  DateSelectorModel copyWith({
    Selector<int>? ddPicker,
    Selector<String>? mmPicker,
    Selector<Year>? yyyyPicker,
  }) {
    return DateSelectorModel._(
      ddPicker: ddPicker ?? this.ddPicker,
      mmPicker: mmPicker ?? this.mmPicker,
      yyyyPicker: yyyyPicker ?? this.yyyyPicker,
      initialValue: initialValue,
      allowDisableDaySelection: allowDisableDaySelection,
      allowDisableYearSelection: allowDisableYearSelection,
    );
  }

  DDMMYYYY get ddmmyyyy {
    final dd = ddPicker.selectedValue;
    final mm = mmPicker.selectedIndex!;
    final yyyy = yyyyPicker.selectedValue;

    return DDMMYYYY(dd: dd, mm: mm, yyyy: yyyy?.value);
  }

  static final List<String> monthsOfTheYear = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  static List<int> daysInMonth(List<Year> years, Year? yy, int mm) {
    final int maxDay;
    List<int> daysInMonthList = <int>[
      31,
      if (yy != null && yy.isLeapYear)
        29
      else if (yy == null && years.leapYears().isNotEmpty)
        29
      else
        28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    maxDay = daysInMonthList[mm];

    final List<int> days = List.generate(maxDay, (i) => i + 1);

    return days;
  }

  DateSelectorModel onReset() {
    final List<Year> yearsSorted = yyyyPicker.items;

    final int dd = initialValue.dd ?? 1;
    final int mm = initialValue.mm; // Indexed from 0
    final int yy = yearsSorted.getIndexOfByInt(initialValue.yyyy) ??
        yearsSorted.length - 1;

    final List<int> days = daysInMonth(yearsSorted, yearsSorted[yy], mm);

    return copyWith(
        ddPicker: ddPicker.copyWith(
            index: dd - 1, items: days, isDisabled: (initialValue.dd == null)),
        mmPicker: mmPicker.copyWith(index: mm),
        yyyyPicker: yyyyPicker.copyWith(
            index: yy, isDisabled: (initialValue.yyyy == null)));
  }

  DateSelectorModel onChange(PickerID pickerID, int index) {
    final pickers = {
      PickerID.ddPicker: ddPicker,
      PickerID.mmPicker: mmPicker,
      PickerID.yyyyPicker: yyyyPicker,
    };
    if (pickers[pickerID]!.isDisabled) return this;
    pickers[pickerID] = pickers[pickerID]!.copyWith(index: index);
    final pickersUpdated = updatePickers(pickers, pickerID);
    return copyWith(
      ddPicker: pickersUpdated[PickerID.ddPicker] as Selector<int>,
      mmPicker: pickersUpdated[PickerID.mmPicker] as Selector<String>,
      yyyyPicker: pickersUpdated[PickerID.yyyyPicker] as Selector<Year>,
    );
  }

  static Map<PickerID, Selector> updatePickers(
    Map<PickerID, Selector> pickers,
    PickerID changedPickerID,
  ) {
    final yyPicker = pickers[PickerID.yyyyPicker] as Selector<Year>;
    final mmPicker = pickers[PickerID.mmPicker] as Selector<String>;
    final ddPicker = pickers[PickerID.ddPicker] as Selector<int>;

    switch (changedPickerID) {
      case PickerID.ddPicker:
        // Need to update year if the date is Feb 29 to nearest Leap Year
        if (ddPicker.selectedIndex == 29 &&
            mmPicker.selectedLabel == monthsOfTheYear[1]) {
          pickers[PickerID.ddPicker] = yyPicker.copyWith(
              index: yyPicker.items.getIndexOf(yyPicker.items
                  .leapYears()
                  .getCloseValue(yyPicker.selectedValue!.value)));
        }
        break;
      case PickerID.mmPicker:
      case PickerID.yyyyPicker:
        // Need to update day as the length will vary

        final days = daysInMonth(yyPicker.items, yyPicker.selectedValue,
            mmPicker.selectedIndex ?? 1);
        pickers[PickerID.ddPicker] = ddPicker.copyWith(
            items: days, index: min(ddPicker.index, days.length - 1));

        break;
    }
    return pickers;
  }

  DateSelectorModel toggleDisable(PickerID pickerID) {
    // Don't allow to disable month Picker
    if (pickerID == PickerID.mmPicker) return this;
    final pickers = {
      PickerID.ddPicker: this.ddPicker,
      PickerID.mmPicker: this.mmPicker,
      PickerID.yyyyPicker: this.yyyyPicker,
    };
    final pickersUpdated = Map.from(pickers);

    pickersUpdated[pickerID] = pickers[pickerID]!.toggleDisable();
    if (pickersUpdated[PickerID.ddPicker]!.isDisabled &&
        pickersUpdated[PickerID.yyyyPicker]!.isDisabled) {
      if (pickerID == PickerID.ddPicker) {
        pickersUpdated[PickerID.yyyyPicker] =
            pickers[PickerID.yyyyPicker]!.toggleDisable();
      } else if (pickerID == PickerID.yyyyPicker) {
        pickersUpdated[PickerID.ddPicker] =
            pickers[PickerID.ddPicker]!.toggleDisable();
      }
    }
    final yyyyPicker = pickers[PickerID.yyyyPicker] as Selector<Year>;
    final mmPicker = pickers[PickerID.mmPicker] as Selector<String>;
    final ddPicker = pickers[PickerID.ddPicker] as Selector<int>;

    final days = daysInMonth(yyyyPicker.items, yyyyPicker.selectedValue,
        mmPicker.selectedIndex ?? 1);
    pickers[PickerID.ddPicker] = ddPicker.copyWith(
        items: days, index: min(ddPicker.index, days.length - 1));

    return copyWith(
      ddPicker: pickersUpdated[PickerID.ddPicker] as Selector<int>,
      mmPicker: pickersUpdated[PickerID.mmPicker] as Selector<String>,
      yyyyPicker: pickersUpdated[PickerID.yyyyPicker] as Selector<Year>,
    );
  }

  @override
  String toString() {
    return 'DateSelectorModel(ddPicker: $ddPicker, mmPicker: $mmPicker, yyyyPicker: $yyyyPicker, initialValue: $initialValue, allowDisableDaySelection: $allowDisableDaySelection, allowDisableYearSelection: $allowDisableYearSelection)';
  }
}
