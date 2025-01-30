import 'package:flutter/material.dart';

import '../model/menu_item.dart';
import '../model/picker.dart';
import '../model/year.dart';
import '../themedata.dart';
import 'menu_item.dart';
import 'picker_view.dart';

class DateSelectorView extends StatelessWidget {
  const DateSelectorView(
      {super.key,
      required this.ddPicker,
      required this.mmPicker,
      required this.yyyyPicker,
      required this.width,
      required this.height,
      required this.itemExtend,
      required this.theme,
      required this.onSelection,
      required this.onToggleDisable,
      required this.onReset});

  final Selector<int> ddPicker;
  final Selector<String> mmPicker;
  final Selector<Year> yyyyPicker;
  final double width;
  final double height;
  final double itemExtend;

  final DateSelectorThemeData theme;
  final void Function({required int index, required PickerID pickerID})
      onSelection;
  final void Function({required PickerID pickerID}) onToggleDisable;
  final void Function() onReset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  PickerView(
                    picker: ddPicker,
                    width: width * 1 / 6,
                    height: height,
                    itemExtent: itemExtend,
                    bottomPadding: kMinInteractiveDimension,
                    theme: theme,
                    onSelection: onSelection,
                  ),
                  PickerView(
                    picker: mmPicker,
                    width: width * 3 / 6,
                    height: height,
                    itemExtent: itemExtend,
                    bottomPadding: kMinInteractiveDimension,
                    theme: theme,
                    onSelection: onSelection,
                  ),
                  PickerView(
                    picker: yyyyPicker,
                    width: width * 2 / 6,
                    height: height,
                    itemExtent: itemExtend,
                    bottomPadding: kMinInteractiveDimension,
                    theme: theme,
                    onSelection: onSelection,
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
                    onTap: () => onToggleDisable(pickerID: PickerID.ddPicker),
                  ),
                  MenuItem(
                    tooltip: 'Restore',
                    iconData: Icons.restart_alt,
                    iconColor: theme.iconColor,
                    width: width * 3 / 6,
                    onTap: onReset,
                  ),
                  MenuItem(
                    tooltip: 'Enable/Disable Year Selection',
                    iconData: Icons.toggle_on,
                    iconColor: theme.iconColor,
                    width: width * 2 / 6,
                    onTap: () => onToggleDisable(pickerID: PickerID.yyyyPicker),
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
