// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ddmmyyyy.dart';
import 'model/menu_item.dart';
import 'model/picker.dart';
import 'provider/date_picker.dart';
import 'themedata.dart';
import 'views/menu_item.dart';
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
    return SizedBox(
      width: width,
      height: height,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PickerView(
                    pickerID: PickerID.datePicker,
                    width: childWidth * 1 / 6,
                    height: childHeight,
                    itemExtent: childHeight / 6,
                    bottomPadding: kMinInteractiveDimension,
                    theme: theme,
                    allowDisable: canDisableDay,
                  ),
                  PickerView(
                    pickerID: PickerID.monthPicker,
                    width: childWidth * 3 / 6,
                    height: childHeight,
                    itemExtent: childHeight / 6,
                    bottomPadding: kMinInteractiveDimension,
                    theme: theme,
                    allowDisable: false,
                  ),
                  PickerView(
                    pickerID: PickerID.yearPicker,
                    width: childWidth * 2 / 6,
                    height: childHeight,
                    itemExtent: childHeight / 6,
                    bottomPadding: kMinInteractiveDimension,
                    theme: theme,
                    allowDisable: canDisableYear,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: kMinInteractiveDimension,
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MenuItem(
                    tooltip: 'Enable/Disable Day Selection',
                    iconData: Icons.toggle_off,
                    iconColor: theme.iconColor,
                    width: childWidth / 6,
                    onTap: () => ref
                        .read(datePickerNotifierProvider.notifier)
                        .toggleDisable(pickerID: PickerID.datePicker),
                  ),
                  MenuItem(
                    tooltip: 'Restore',
                    iconData: Icons.restart_alt,
                    iconColor: theme.iconColor,
                    width: childWidth * 3 / 6,
                    onTap: () =>
                        ref.read(datePickerNotifierProvider.notifier).onReset(),
                  ),
                  MenuItem(
                    tooltip: 'Enable/Disable Year Selection',
                    iconData: Icons.toggle_on,
                    iconColor: theme.iconColor,
                    width: childWidth * 2 / 6,
                    onTap: () => ref
                        .read(datePickerNotifierProvider.notifier)
                        .toggleDisable(pickerID: PickerID.yearPicker),
                  ),
                ]
                    .map((e) =>
                        SizedBox(width: e.width, child: MenuItemView(item: e)))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
