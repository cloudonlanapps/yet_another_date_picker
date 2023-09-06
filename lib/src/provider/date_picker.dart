import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/date_picker.dart';
import '../ddmmyyyy.dart';

enum UpdateType { none, date, month, year }

class DatePickerNotifier extends StateNotifier<DatePicker> {
  UpdateType updateType = UpdateType.none;
  final void Function(DDMMYYYY ddmmyyyy) onDateChange;
  final DDMMYYYY initialDate;
  DatePickerNotifier({
    required List<int> years,
    required this.initialDate,
    required this.onDateChange,
  }) : super(DatePicker(years: years, initialValue: initialDate));
  void onChangeDD(int dd) {
    if (state.ddPicker.index == dd || updateType != UpdateType.none) return;

    updateType = UpdateType.date;
    state = state.onChangeDD(dd);
    onDateChange(state.ddmmyyyy);
    updateType = UpdateType.none;
  }

  void onChangeMM(int mm) {
    if (state.mmPicker.index == mm || updateType != UpdateType.none) return;
    updateType = UpdateType.month;
    state = state.onChangeMM(mm);
    onDateChange(state.ddmmyyyy);
    updateType = UpdateType.none;
  }

  onChangeYY(int yy) {
    if (state.yyPicker.index == yy || updateType != UpdateType.none) return;
    updateType = UpdateType.year;
    state = state.onChangeYY(yy);
    onDateChange(state.ddmmyyyy);
    updateType = UpdateType.none;
  }

  onReset() {
    state = state.onReset();
    onDateChange(state.ddmmyyyy);
  }
}

final datePickerNotifierProvider =
    StateNotifierProvider<DatePickerNotifier, DatePicker>((ref) {
  throw Exception("Can't access outside Module");
});
