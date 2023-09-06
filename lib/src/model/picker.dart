import 'package:flutter/material.dart';

class XXPicker<T> {
  final String name;
  final int index;
  final List<T> items;
  final FixedExtentScrollController controller;
  final int? padding;
  final void Function(T value) toStringFormatted;

  XXPicker._(
      {required this.name,
      required this.index,
      required this.items,
      required this.controller,
      this.padding,
      void Function(T value)? toStringFormatted})
      : toStringFormatted =
            (toStringFormatted ?? (T value) => value.toString());

  List<String> get labels => items
      .map((e) => (e == null) ? "any" : e.toString().padLeft(2, '0'))
      .toList();

  T? get selectedValue => items[index];
  String get selectedLabel => labels[index];

  XXPicker<T> copyWith({
    int? index,
    List<T>? items,
  }) {
    var index_ = index ?? this.index;
    final items_ = items ?? this.items;

    index_ = (index_ > items_.length) ? items_.length - 1 : index_;

    final p = XXPicker._(
      name: name,
      index: index_,
      items: items_,
      controller: controller,
    );

    return p;
  }

  scrollTo() {
    if (index == controller.selectedItem) return;
    controller.jumpToItem(index);
  }

  factory XXPicker({
    required String name,
    required int index,
    required List<T> items,
  }) {
    return XXPicker._(
      name: name,
      index: index,
      items: items,
      controller: FixedExtentScrollController(initialItem: index),
    );
  }
}
