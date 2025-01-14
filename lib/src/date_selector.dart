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
  final String uid;
  final List<int> years;
  final DDMMYYYY initialDate;
  final Future<void> Function(DDMMYYYY ddmmyyyy) onDateChanged;
  final bool allowDisableDaySelection;
  final bool allowDisableYearSelection;
  final double width;
  final double height;
  final double? itemExtend;

  final DateSelectorThemeData? dateSelectorThemeData;
  const DateSelector({
    this.uid = "Default",
    super.key,
    required this.years,
    required this.initialDate,
    required this.onDateChanged,
    this.allowDisableDaySelection = true,
    this.allowDisableYearSelection = true,
    this.width = 252,
    this.height = 252,
    this.itemExtend,
    this.dateSelectorThemeData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        datePickerNotifierProvider(uid)
            .overrideWith((ref) => DatePickerNotifier(
                  years: years,
                  initialDate: initialDate,
                  onDateChange: onDateChanged,
                )),
      ],
      child: _DateSelector(
          uid: uid,
          width: width,
          height: height,
          itemExtend: itemExtend ?? width / 6,
          theme: dateSelectorThemeData ?? defaultTheme),
    );
  }
}

class _DateSelector extends ConsumerWidget {
  const _DateSelector({
    required this.uid,
    required this.width,
    required this.height,
    required this.itemExtend,
    required this.theme,
  });
  final String uid;
  final double width;
  final double height;
  final double itemExtend;

  final DateSelectorThemeData theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool canDisableDay = ref.watch(datePickerNotifierProvider(uid)
        .select((value) => value.allowDisableDaySelection));
    bool canDisableYear = ref.watch(datePickerNotifierProvider(uid)
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  PickerView(
                    uid: uid,
                    pickerID: PickerID.datePicker,
                    width: width * 1 / 6,
                    height: height,
                    itemExtent: itemExtend,
                    bottomPadding: kMinInteractiveDimension,
                    theme: theme,
                    allowDisable: canDisableDay,
                  ),
                  PickerView(
                    uid: uid,
                    pickerID: PickerID.monthPicker,
                    width: width * 3 / 6,
                    height: height,
                    itemExtent: itemExtend,
                    bottomPadding: kMinInteractiveDimension,
                    theme: theme,
                    allowDisable: false,
                  ),
                  PickerView(
                    uid: uid,
                    pickerID: PickerID.yearPicker,
                    width: width * 2 / 6,
                    height: height,
                    itemExtent: itemExtend,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MenuItem(
                    tooltip: 'Enable/Disable Day Selection',
                    iconData: Icons.toggle_off,
                    iconColor: theme.iconColor,
                    width: width / 6,
                    onTap: () => ref
                        .read(datePickerNotifierProvider(uid).notifier)
                        .toggleDisable(pickerID: PickerID.datePicker),
                  ),
                  MenuItem(
                    tooltip: 'Restore',
                    iconData: Icons.restart_alt,
                    iconColor: theme.iconColor,
                    width: width * 3 / 6,
                    onTap: () => ref
                        .read(datePickerNotifierProvider(uid).notifier)
                        .onReset(),
                  ),
                  MenuItem(
                    tooltip: 'Enable/Disable Year Selection',
                    iconData: Icons.toggle_on,
                    iconColor: theme.iconColor,
                    width: width * 2 / 6,
                    onTap: () => ref
                        .read(datePickerNotifierProvider(uid).notifier)
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
