import 'dart:math';
import 'dart:collection';

class Year {
  final int value;

  /// This software require past dates, can't have future dates
  /// Debatable ???

  Year(int value) : value = min(max(value, 1970), DateTime.now().year);

  bool get isLeapYear =>
      (value % 4 == 0) && (value % 100 != 0) || (value % 400 == 0);

  @override
  bool operator ==(covariant Year other) {
    if (identical(this, other)) return true;

    return other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => '$value';
}

extension Approximate on List<Year> {
  Year? getCloseValue(int x) {
    if (isEmpty) return null;
    Map<Year, int> values = {};
    forEach((e) {
      values[e] = (e.value - x).abs();
    });
    var sortedKeys = values.keys.toList(growable: false)
      ..sort((k1, k2) => values[k1]!.compareTo(values[k2]!));

    final sortedMap = LinkedHashMap.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => values[k]);
    return sortedMap.keys.first;
  }
}

extension FindIndex on List<Year?> {
  int? getIndexOf(Year? year) {
    if (year == null) return null;
    final index =
        indexWhere((y) => (y != null) ? y.value == year.value : false);
    return (index == -1) ? null : index;
  }

  List<Year> leapYears() {
    final l = where((year) => year != null && year.isLeapYear).toList();

    return l.whereType<Year>().toList();
  }
}
