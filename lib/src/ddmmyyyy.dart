// ignore_for_file: public_member_api_docs, sort_constructors_first
class DDMMYYYY {
  final int? dd;
  final int mm;
  final int? yyyy;
  DDMMYYYY({required this.dd, required this.mm, required this.yyyy});

  @override
  String toString() =>
      'DDMMYYYY(dd: ${dd.toString().padLeft(2, '0')}, mm: $mm, yyyy: $yyyy)';
}
