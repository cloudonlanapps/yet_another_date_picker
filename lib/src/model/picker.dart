import 'package:flutter/material.dart';

enum PickerID {
  datePicker,
  monthPicker,
  yearPicker,
}

class Selector<T> {
  final PickerID pickerID;
  final int index;
  final List<T> items;
  final FixedExtentScrollController controller;

  final String Function(T value) toStringFormatted;
  final bool isDisabled;

  Selector._({
    required this.pickerID,
    required this.index,
    required this.items,
    required this.controller,
    required this.isDisabled,
    required this.toStringFormatted,
  });

  factory Selector(
      {required PickerID pickerID,
      required int index,
      required List<T> items,
      bool? isDisabled,
      String Function(T value)? toStringFormatted}) {
    return Selector._(
        pickerID: pickerID,
        index: index,
        items: items,
        controller: FixedExtentScrollController(initialItem: index),
        isDisabled: isDisabled ?? false,
        toStringFormatted: toStringFormatted ?? (T value) => value.toString());
  }

  Selector<T> copyWith({
    int? index,
    List<T>? items,
    bool? isDisabled,
  }) {
    var index_ = index ?? this.index;
    final items_ = items ?? this.items;

    index_ = (index_ > items_.length) ? items_.length - 1 : index_;

    final p = Selector._(
        pickerID: pickerID,
        index: index_,
        items: items_,
        controller: controller,
        isDisabled: isDisabled ?? this.isDisabled,
        toStringFormatted: toStringFormatted);

    return p;
  }

  scrollTo({bool animate = false}) {
    if (index == controller.selectedItem) return;
    if (animate) {
      controller.animateToItem(index,
          duration: const Duration(microseconds: 300), curve: Curves.ease);
    } else {
      controller.jumpToItem(index);
    }
  }

  List<String> get labels => items.map((e) => toStringFormatted(e)).toList();

  int? get selectedIndex => isDisabled
      ? null
      : index > 0
          ? index
          : 0;
  T? get selectedValue => isDisabled ? null : items[index > 0 ? index : 0];
  String get selectedLabel => isDisabled ? "" : labels[index > 0 ? index : 0];

  Selector<T> toggleDisable() {
    return copyWith(isDisabled: !isDisabled);
  }

  @override
  String toString() {
    return 'Selector(pickerID: $pickerID, index: $index, items: $items, toStringFormatted: $toStringFormatted, isDisabled: $isDisabled)';
  }
}
