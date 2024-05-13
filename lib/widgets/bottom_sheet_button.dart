import 'package:flutter/material.dart';
import 'package:phonebook/util/responsive_extensions.dart';

import '../core/theme/app_colors.dart';

class BottomSheetButton extends StatelessWidget {
  const BottomSheetButton({super.key, required this.onTap, required this.children});

  final List<Widget> children;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: context.getHeight(54),
        decoration: BoxDecoration(
          color: AppColors.pageColor,
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
