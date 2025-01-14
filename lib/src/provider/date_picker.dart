import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/date_picker.dart';
import '../ddmmyyyy.dart';
import '../model/picker.dart';

enum UpdateType { none, date, month, year }

class DatePickerNotifier extends StateNotifier<DateSelector> {
  bool isUpdating = false;
  final void Function(DDMMYYYY ddmmyyyy) onDateChange;
  final DDMMYYYY initialDate;

  DatePickerNotifier({
    required List<int> years,
    required this.initialDate,
    required this.onDateChange,
    bool allowDisableDaySelection = true,
    bool allowDisableYearSelection = true,
  }) : super(DateSelector(
          years: years,
          initialValue: initialDate,
          allowDisableDaySelection: allowDisableDaySelection,
          allowDisableYearSelection: allowDisableYearSelection,
        ));

  void onChange({required int index, required PickerID pickerID}) {
    if (!state.pickers[pickerID]!.isDisabled) {
      safeCall(() {
        state = state.onChange(pickerID, index);
        onDateChange(state.ddmmyyyy);
      });
    }
  }

  onReset() {
    safeCall(() {
      state = state.onReset();
      onDateChange(state.ddmmyyyy);
    });
  }

  toggleDisable({required PickerID pickerID}) {
    safeCall(() {
      state = state.toggleDisable(pickerID);
      onDateChange(state.ddmmyyyy);
    });
  }

  safeCall(Function() fn) {
    if (isUpdating != false) {
      return;
    }
    isUpdating = true;
    fn();
    isUpdating = false;
  }
}

final datePickerNotifierProvider =
    StateNotifierProvider.family<DatePickerNotifier, DateSelector, String>(
        (ref, uid) {
  throw Exception("Can't access outside Module");
});
