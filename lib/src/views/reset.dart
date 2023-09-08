import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/date_picker.dart';

class ResetIcon extends ConsumerWidget {
  final Color color;
  const ResetIcon({
    super.key,
    required this.color,
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
                color: color,
              )),
        ),
      ],
    );
  }
}
