import 'dart:math';

import '../ddmmyyyy.dart';
import 'year.dart';
import 'picker.dart';

class DatePicker {
  late final Map<PickerID, XXPicker> pickers;
  final DDMMYYYY initialValue;
  final bool allowDisableDaySelection;
  final bool allowDisableYearSelection;

  DatePicker._({
    required XXPicker ddPicker,
    required XXPicker mmPicker,
    required XXPicker yyPicker,
    required this.initialValue,
    required this.allowDisableDaySelection,
    required this.allowDisableYearSelection,
  }) : pickers = {
          PickerID.datePicker: ddPicker,
          PickerID.monthPicker: mmPicker,
          PickerID.yearPicker: yyPicker
        };

  factory DatePicker({
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

    return DatePicker._(
        ddPicker: XXPicker<int>(
          pickerID: PickerID.datePicker,
          index: dd,
          items: days,
        ),
        mmPicker: XXPicker<String>(
            pickerID: PickerID.monthPicker, index: mm, items: monthsOfTheYear),
        yyPicker: XXPicker<Year>(
            pickerID: PickerID.yearPicker, index: yy, items: yearsSorted),
        allowDisableDaySelection: allowDisableDaySelection,
        allowDisableYearSelection: allowDisableYearSelection,
        initialValue: initialValue);
  }
  DatePicker copyWith({
    XXPicker<int>? ddPicker,
    XXPicker<String>? mmPicker,
    XXPicker<Year>? yyPicker,
  }) {
    return DatePicker._(
      ddPicker: ddPicker ?? pickers[PickerID.datePicker] as XXPicker<int>,
      mmPicker: mmPicker ?? pickers[PickerID.monthPicker] as XXPicker<String>,
      yyPicker: yyPicker ?? pickers[PickerID.yearPicker] as XXPicker<Year>,
      initialValue: initialValue,
      allowDisableDaySelection: allowDisableDaySelection,
      allowDisableYearSelection: allowDisableYearSelection,
    );
  }

  DDMMYYYY get ddmmyyyy {
    final dd = pickers[PickerID.datePicker]!.selectedValue;
    final mm = pickers[PickerID.monthPicker]!.selectedIndex!;
    final yyyy = pickers[PickerID.yearPicker]!.selectedValue;

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

  DatePicker onReset() {
    final List<Year> yearsSorted =
        pickers[PickerID.yearPicker]!.items as List<Year>;

    final int dd = (initialValue.dd == null) ? 0 : initialValue.dd!;
    final int mm = initialValue.mm; // Indexed from 0
    final int yy = yearsSorted.getIndexOfByInt(initialValue.yyyy) ??
        yearsSorted.length - 1;

    final List<int> days = daysInMonth(yearsSorted, yearsSorted[yy], mm);

    return copyWith(
        ddPicker: pickers[PickerID.datePicker]!.copyWith(
            index: dd,
            items: days,
            isDisabled: (initialValue.dd == null)) as XXPicker<int>,
        mmPicker: pickers[PickerID.monthPicker]!.copyWith(index: mm)
            as XXPicker<String>,
        yyPicker: pickers[PickerID.yearPicker]!.copyWith(
            index: yy,
            isDisabled: (initialValue.yyyy == null)) as XXPicker<Year>);
  }

  DatePicker onChange(PickerID pickerID, int index) {
    final pickers = this.pickers;
    if (pickers[pickerID]!.isDisabled) return this;
    pickers[pickerID] = pickers[pickerID]!.copyWith(index: index);
    final pickersUpdated = updatePickers(pickers, pickerID);
    return copyWith(
      ddPicker: pickersUpdated[PickerID.datePicker] as XXPicker<int>,
      mmPicker: pickersUpdated[PickerID.monthPicker] as XXPicker<String>,
      yyPicker: pickersUpdated[PickerID.yearPicker] as XXPicker<Year>,
    );
  }

  static Map<PickerID, XXPicker> updatePickers(
    Map<PickerID, XXPicker> pickers,
    PickerID changedPickerID,
  ) {
    final yyPicker = pickers[PickerID.yearPicker] as XXPicker<Year>;
    final mmPicker = pickers[PickerID.monthPicker] as XXPicker<String>;
    final ddPicker = pickers[PickerID.datePicker] as XXPicker<int>;

    switch (changedPickerID) {
      case PickerID.datePicker:
        // Need to update year if the date is Feb 29 to nearest Leap Year
        if (ddPicker.selectedIndex == 29 &&
            mmPicker.selectedLabel == monthsOfTheYear[1]) {
          pickers[PickerID.datePicker] = yyPicker.copyWith(
              index: yyPicker.items.getIndexOf(yyPicker.items
                  .leapYears()
                  .getCloseValue(yyPicker.selectedValue!.value)));
        }
        break;
      case PickerID.monthPicker:
      case PickerID.yearPicker:
        // Need to update day as the length will vary

        final days = daysInMonth(yyPicker.items, yyPicker.selectedValue,
            mmPicker.selectedIndex ?? 1);
        pickers[PickerID.datePicker] = ddPicker.copyWith(
            items: days, index: min(ddPicker.index, days.length - 1));

        break;
    }
    return pickers;
  }

  DatePicker toggleDisable(PickerID pickerID) {
    final pickersUpdated = pickers;
    // Don't allow to disable month Picker
    if (pickerID == PickerID.monthPicker) return this;

    pickersUpdated[pickerID] = pickers[pickerID]!.toggleDisable();
    if (pickersUpdated[PickerID.datePicker]!.isDisabled &&
        pickersUpdated[PickerID.yearPicker]!.isDisabled) {
      if (pickerID == PickerID.datePicker) {
        pickersUpdated[PickerID.yearPicker] =
            pickers[PickerID.yearPicker]!.toggleDisable();
      } else if (pickerID == PickerID.yearPicker) {
        pickersUpdated[PickerID.datePicker] =
            pickers[PickerID.datePicker]!.toggleDisable();
      }
    }
    final yyPicker = pickers[PickerID.yearPicker] as XXPicker<Year>;
    final mmPicker = pickers[PickerID.monthPicker] as XXPicker<String>;
    final ddPicker = pickers[PickerID.datePicker] as XXPicker<int>;

    final days = daysInMonth(
        yyPicker.items, yyPicker.selectedValue, mmPicker.selectedIndex ?? 1);
    pickers[PickerID.datePicker] = ddPicker.copyWith(
        items: days, index: min(ddPicker.index, days.length - 1));

    return copyWith(
      ddPicker: pickersUpdated[PickerID.datePicker] as XXPicker<int>,
      mmPicker: pickersUpdated[PickerID.monthPicker] as XXPicker<String>,
      yyPicker: pickersUpdated[PickerID.yearPicker] as XXPicker<Year>,
    );
  }
}
