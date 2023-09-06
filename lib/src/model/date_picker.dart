import 'dart:math';

import '../ddmmyyyy.dart';
import 'year.dart';
import 'picker.dart';

class DatePicker {
  final XXPicker<int?> ddPicker;
  final XXPicker<String> mmPicker;
  final XXPicker<Year?> yyPicker;
  final DDMMYYYY initialValue;

  DatePicker._(
      {required this.ddPicker,
      required this.mmPicker,
      required this.yyPicker,
      required this.initialValue});

  factory DatePicker({
    required List<int> years,
    required DDMMYYYY initialValue,
  }) {
    final List<Year?> yearsSorted = [
      null, // For Any
      ...years.map((e) => Year(e)).toList()
        ..sort((a, b) => a.value.compareTo(b.value)),
    ];

    final int dd = (initialValue.dd == null) ? 0 : initialValue.dd!;
    final int mm = initialValue.mm; // Indexed from 0
    final int yy = yearsSorted.getIndexOfByInt(initialValue.yyyy) ??
        yearsSorted.length - 1;

    final List<int?> days = daysInMonth(yearsSorted, yearsSorted[yy], mm);

    return DatePicker._(
        ddPicker: XXPicker<int?>(name: "day", index: dd, items: days),
        mmPicker:
            XXPicker<String>(name: " month", index: mm, items: monthsOfTheYear),
        yyPicker: XXPicker<Year?>(name: "year", index: yy, items: yearsSorted),
        initialValue: initialValue);
  }
  DatePicker copyWith({
    XXPicker<int?>? ddPicker,
    XXPicker<String>? mmPicker,
    XXPicker<Year?>? yyPicker,
  }) {
    return DatePicker._(
        ddPicker: ddPicker ?? this.ddPicker,
        mmPicker: mmPicker ?? this.mmPicker,
        yyPicker: yyPicker ?? this.yyPicker,
        initialValue: initialValue);
  }

  DDMMYYYY get ddmmyyyy {
    final dd = ddPicker.selectedValue;
    final mm = mmPicker.selectedLabel;
    final yyyy = yyPicker.selectedValue;

    return DDMMYYYY(dd: dd, mm: monthsOfTheYear.indexOf(mm), yyyy: yyyy?.value);
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
  static List<int?> daysInMonth(List<Year?> years, Year? yy, int mm) {
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

    final List<int?> days = List.generate(maxDay + 1, (i) => i == 0 ? null : i);

    return days;
  }

  DatePicker onChangeMM(int mmIndex) {
    final days =
        daysInMonth(yyPicker.items, yyPicker.items[yyPicker.index], mmIndex);

    final n = copyWith(
        mmPicker: mmPicker.copyWith(index: mmIndex),
        ddPicker: ddPicker.copyWith(
            items: days, index: min(ddPicker.index, days.length - 1)));
    return n;
  }

  DatePicker onChangeDD(int dd) {
    var ddPicker = this.ddPicker.copyWith(index: dd);
    XXPicker<Year?>? yyPicker;

    if (ddPicker.selectedValue == null && this.yyPicker.selectedValue == null) {
      yyPicker = this.yyPicker.copyWith(index: this.yyPicker.items.length - 1);
    } else if (ddPicker.items[dd] == 29 &&
        mmPicker.selectedLabel == monthsOfTheYear[1] &&
        this.yyPicker.selectedValue != null) {
      yyPicker = this.yyPicker.copyWith(
          index: this.yyPicker.items.getIndexOf(this
              .yyPicker
              .items
              .leapYears()
              .getCloseValue(this.yyPicker.selectedValue!.value)));
    }

    return copyWith(ddPicker: ddPicker, yyPicker: yyPicker);
  }

  DatePicker onChangeYY(int yy) {
    XXPicker<int?>? ddPicker;
    final yyPicker = this.yyPicker.copyWith(index: yy);
    final days =
        daysInMonth(yyPicker.items, yyPicker.items[yy], mmPicker.index);

    if (this.ddPicker.selectedValue == null && yyPicker.selectedValue == null) {
      ddPicker = this.ddPicker.copyWith(index: 1, items: days);
    } else {
      ddPicker = this.ddPicker.copyWith(
          items: days, index: min(this.ddPicker.index, days.length - 1));
    }
    return copyWith(ddPicker: ddPicker, yyPicker: yyPicker);
  }

  DatePicker onReset() {
    final List<Year?> yearsSorted = yyPicker.items;

    final int dd = (initialValue.dd == null) ? 0 : initialValue.dd!;
    final int mm = initialValue.mm; // Indexed from 0
    final int yy = yearsSorted.getIndexOfByInt(initialValue.yyyy) ??
        yearsSorted.length - 1;

    final List<int?> days = daysInMonth(yearsSorted, yearsSorted[yy], mm);

    return copyWith(
        ddPicker: ddPicker.copyWith(index: dd, items: days),
        mmPicker: mmPicker.copyWith(index: mm),
        yyPicker: yyPicker.copyWith(index: yy));
  }
}
