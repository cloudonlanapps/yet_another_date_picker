// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yet_another_date_picker/src/model/picker.dart';

import 'themedata.dart';
import 'provider/date_picker.dart';
import 'ddmmyyyy.dart';
import 'views/reset.dart';
import 'views/picker_view.dart';

class DateSelector extends ConsumerWidget {
  final List<int> years;
  final DDMMYYYY initialDate;
  final Future<void> Function(DDMMYYYY ddmmyyyy) onDateChanged;
  final bool allowDisableDaySelection;
  final bool allowDisableYearSelection;
  final double width;
  final double height;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final DateSelectorThemeData? dateSelectorThemeData;
  const DateSelector(
      {super.key,
      required this.years,
      required this.initialDate,
      required this.onDateChanged,
      this.allowDisableDaySelection = true,
      this.allowDisableYearSelection = true,
      this.width = 252,
      this.height = 252,
      EdgeInsets? margin,
      EdgeInsets? padding,
      this.dateSelectorThemeData})
      : margin = margin ?? const EdgeInsets.all(4.0),
        padding = padding ?? const EdgeInsets.all(4.0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childWidth = width - padding.left - padding.right;
    final childHeight = height - padding.top - padding.bottom;
    final DateSelectorThemeData defaultTheme = DateSelectorThemeData(
      backgroundColor: Theme.of(context).colorScheme.secondary,
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
    return ProviderScope(
      overrides: [
        datePickerNotifierProvider.overrideWith((ref) => DatePickerNotifier(
              years: years,
              initialDate: initialDate,
              onDateChange: onDateChanged,
            )),
      ],
      child: _DateSelector(
          margin: margin,
          padding: padding,
          width: width,
          height: height,
          childWidth: childWidth,
          childHeight: childHeight,
          theme: dateSelectorThemeData ?? defaultTheme),
    );
  }
}

class _DateSelector extends ConsumerWidget {
  const _DateSelector({
    required this.margin,
    required this.padding,
    required this.width,
    required this.height,
    required this.childWidth,
    required this.childHeight,
    required this.theme,
  });

  final EdgeInsets margin;
  final EdgeInsets padding;
  final double width;
  final double height;
  final double childWidth;
  final double childHeight;
  final DateSelectorThemeData theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool canDisableDay = ref.watch(datePickerNotifierProvider
        .select((value) => value.allowDisableDaySelection));
    bool canDisableYear = ref.watch(datePickerNotifierProvider
        .select((value) => value.allowDisableDaySelection));
    return Container(
      margin: margin,
      padding: padding,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border.all(
            width: 0.25, color: Theme.of(context).colorScheme.primaryContainer),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primaryContainer,
            blurRadius: 2.0, // soften the shadow
            spreadRadius: 2.0, //extend the shadow
            offset: const Offset(
              2.0, // Move to right 5  horizontally
              2.0, // Move to bottom 5 Vertically
            ),
          )
        ],
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PickerView(
                  pickerID: PickerID.datePicker,
                  width: childWidth * 1 / 6,
                  height: childHeight,
                  itemExtent: childHeight / 6,
                  bottomPadding: 0,
                  theme: theme,
                  allowDisable: canDisableDay,
                ),
                PickerView(
                  pickerID: PickerID.monthPicker,
                  width: childWidth * 3 / 6,
                  height: childHeight,
                  itemExtent: childHeight / 6,
                  bottomPadding: 0,
                  theme: theme,
                  allowDisable: false,
                ),
                PickerView(
                  pickerID: PickerID.yearPicker,
                  width: childWidth * 2 / 6,
                  height: childHeight,
                  itemExtent: childHeight / 6,
                  bottomPadding: 0,
                  theme: theme,
                  allowDisable: canDisableYear,
                ),
              ],
            ),
            Positioned(
                top: 0,
                right: 0,
                child: ResetIcon(
                  color: theme.iconColor,
                ))
          ],
        ),
      ),
    );
  }
}
