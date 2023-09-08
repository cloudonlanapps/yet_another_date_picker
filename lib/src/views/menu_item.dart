import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/menu_item.dart';

class MenuItemView extends ConsumerWidget {
  final MenuItem item;
  const MenuItemView({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: item.onTap,
      child: Tooltip(
          message: item.tooltip,
          child: Icon(item.iconData, size: 28, color: item.iconColor)),
    );
  }
}
