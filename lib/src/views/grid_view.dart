// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../themedata.dart';
import '../model/picker.dart';

class GridViewSelector extends StatelessWidget {
  const GridViewSelector({
    super.key,
    required this.picker,
    this.onSelection,
    required this.theme,
  });

  final Selector picker;
  final Function(int index)? onSelection;
  final DateSelectorThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
          shadowColor: theme.backgroundColor,
          color: theme.backgroundColorDisabled,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 2.0,
                  runSpacing: 4.0,
                  children: [
                    for (var i = 0; i < picker.items.length; i++)
                      ActionChip(
                        onPressed: () {
                          onSelection?.call(i);
                          Navigator.pop(context, true);
                        },
                        shape: null,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        label: Text(picker.labels[i],
                            style: theme.textStyleSelected),
                        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                      )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, right: 8.0, bottom: 8.0),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context, false);
                        },
                        child: Text("Cancel", style: theme.textStyleSelected)),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
