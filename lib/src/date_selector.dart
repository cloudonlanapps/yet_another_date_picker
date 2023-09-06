// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'model/picker.dart';
import 'provider/date_picker.dart';
import 'views/list_wheel.dart';
import 'ddmmyyyy.dart';

class DateSelector extends ConsumerWidget {
  final List<int> years;
  final DDMMYYYY initialDate;
  final Future<void> Function(DDMMYYYY ddmmyyyy) onDateChanged;

  const DateSelector({
    super.key,
    required this.years,
    required this.initialDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        datePickerNotifierProvider.overrideWith((ref) => DatePickerNotifier(
              years: years,
              initialDate: initialDate,
              onDateChange: onDateChanged,
            ))
      ],
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          margin: const EdgeInsets.all(4.0),
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            border: Border.all(
                width: 0.25,
                color: Theme.of(context).colorScheme.primaryContainer),
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
          width: 240 + 8 * 2 + 20,
          height: kMinInteractiveDimension * 5,
          child: const Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DayWheel(width: 40, height: 120),
                  MonthWheel(width: 120, height: 120),
                  YearWheel(width: 80, height: 120),
                ],
              ),
              Positioned(top: 0, right: 0, child: ResetIcon())
            ],
          ),
        ),
      ),
    );
  }
}

class ResetIcon extends ConsumerWidget {
  const ResetIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Tooltip(
          message: "Restore original date",
          child: GestureDetector(
              onTap: () {
                ref.read(datePickerNotifierProvider.notifier).onReset();
              },
              child: Icon(
                Icons.restart_alt_rounded,
                color: Theme.of(context).colorScheme.primary,
              )),
        ),
      ],
    );
  }
}

class DayWheel extends ConsumerWidget {
  final double height;
  final double width;

  const DayWheel({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final XXPicker picker =
        ref.watch(datePickerNotifierProvider.select((value) => value.ddPicker));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      picker.scrollTo();
    });
    return ListWheel(
        picker: picker,
        width: width,
        height: height,
        onSelection: (value) {
          ref.read(datePickerNotifierProvider.notifier).onChangeDD(value);
        });
  }
}

class MonthWheel extends ConsumerWidget {
  const MonthWheel({
    super.key,
    required this.height,
    required this.width,
  });
  final double height;
  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final XXPicker picker =
        ref.watch(datePickerNotifierProvider.select((value) => value.mmPicker));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      picker.scrollTo();
    });
    return ListWheel(
        picker: picker,
        width: width,
        height: height,
        onSelection: (value) {
          ref.read(datePickerNotifierProvider.notifier).onChangeMM(value);
        });
  }
}

class YearWheel extends ConsumerWidget {
  const YearWheel({
    super.key,
    required this.height,
    required this.width,
  });
  final double height;
  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final XXPicker picker =
        ref.watch(datePickerNotifierProvider.select((value) => value.yyPicker));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      picker.scrollTo();
    });
    return ListWheel(
        picker: picker,
        width: width,
        height: height,
        onSelection: (value) {
          ref.read(datePickerNotifierProvider.notifier).onChangeYY(value);
        });
  }
}
