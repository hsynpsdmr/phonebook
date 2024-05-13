import 'package:flutter/material.dart';
import 'package:phonebook/util/responsive_extensions.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_fonts.dart';

class ContactTextFormField extends StatelessWidget {
  const ContactTextFormField({super.key, required this.controller, required this.keyboardType, required this.hintText, required this.onChanged});

  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.getPadding(10.0), horizontal: context.getPadding(12.5)),
      child: TextFormField(
        controller: controller,
        style: AppFonts().bodyLarge.copyWith(color: AppColors.black),
        keyboardType: keyboardType,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.pageColor,
          hintText: hintText,
          hintStyle: AppFonts().bodyLarge.copyWith(color: AppColors.grey),
          contentPadding: EdgeInsets.symmetric(
            horizontal: context.getPadding(20),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.black, width: 1.0),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
