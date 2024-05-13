import 'package:flutter/material.dart';
import 'package:phonebook/core/theme/app_colors.dart';
import 'package:phonebook/core/theme/app_fonts.dart';
import 'package:phonebook/util/responsive_extensions.dart';
import 'package:provider/provider.dart';

import '../app_provider.dart';
import '../core/constants/icon_constant.dart';

class AppSnackBar extends StatefulWidget {
  const AppSnackBar({super.key});

  @override
  State<AppSnackBar> createState() => _AppSnackBarState();
}

class _AppSnackBarState extends State<AppSnackBar> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            context.read<AppProvider>().setSnackBarMessage('');
            context.read<AppProvider>().setShowSnackBar(false);
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      height: context.getHeight(84),
      padding: EdgeInsets.only(left: context.getPadding(30)),
      clipBehavior: Clip.antiAlias,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 40.10,
            offset: Offset(0, -6),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            IconConstant.instance.success,
            width: context.getWidth(24),
            height: context.getHeight(24),
          ),
          SizedBox(width: context.getWidth(15)),
          Text(
            context.watch<AppProvider>().snackBarMessage,
            style: AppFonts().bodyLarge.copyWith(color: AppColors.green),
          ),
        ],
      ),
    );
  }
}
