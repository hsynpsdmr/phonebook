import 'package:flutter/material.dart';
import 'package:phonebook/util/responsive_extensions.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_fonts.dart';

class ContactText extends StatelessWidget {
  const ContactText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.all(context.getPadding(12.5)),
            child: Text(
              text,
              style: AppFonts().bodyLarge.copyWith(
                    color: AppColors.black,
                  ),
            ),
          ),
        ),
        Container(
          decoration: const ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: Color(0xFFB9B9B9),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
