import 'package:flutter/material.dart';
import 'package:phonebook/util/responsive_extensions.dart';
import 'package:phonebook/widgets/bottom_sheet_button.dart';
import 'package:provider/provider.dart';

import '../app_provider.dart';
import '../core/constants/icon_constant.dart';
import '../core/constants/string_constant.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_fonts.dart';
import '../services/contact_service.dart';

class AppBottomSheet {
  Future<dynamic> showDeleteAccount(BuildContext context, String contactID) {
    return showModalBottomSheet(
      isDismissible: false,
      context: context,
      constraints: BoxConstraints(
        maxHeight: context.getHeight(250),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.all(context.getPadding(30)),
        child: Column(
          children: [
            Text(
              StringConstant.deleteAccount,
              style: AppFonts().titleLarge.copyWith(color: AppColors.redDeleteAccount),
            ),
            SizedBox(height: context.getHeight(25)),
            BottomSheetButton(
              onTap: () {
                ContactService().deleteContact(contactID).then((value) {
                  if (value.status == 200) {
                    context.read<AppProvider>().setSnackBarMessage(StringConstant.contactDeleted);
                    context.read<AppProvider>().setShowSnackBar(true);
                    context.read<AppProvider>().setIsRefresh(true);
                    Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
                  }
                });
              },
              children: [
                Text(
                  StringConstant.yes,
                  style: AppFonts().titleLarge.copyWith(color: AppColors.black),
                )
              ],
            ),
            SizedBox(height: context.getHeight(15)),
            BottomSheetButton(
              onTap: () {
                Navigator.pop(context);
              },
              children: [
                Text(
                  StringConstant.no,
                  style: AppFonts().titleLarge.copyWith(color: AppColors.black),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> showImage(BuildContext context, {Function()? camera, Function()? gallery}) {
    return showModalBottomSheet(
      isDismissible: false,
      context: context,
      constraints: BoxConstraints(
        maxHeight: context.getHeight(252),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.all(context.getPadding(30)),
        child: Column(
          children: [
            BottomSheetButton(
              onTap: camera!,
              children: [
                Image.asset(
                  IconConstant.instance.camera,
                  width: context.getWidth(24),
                  height: context.getHeight(24),
                ),
                SizedBox(width: context.getWidth(15)),
                Text(
                  StringConstant.camera,
                  style: AppFonts().titleLarge.copyWith(color: AppColors.black),
                )
              ],
            ),
            SizedBox(height: context.getHeight(15)),
            BottomSheetButton(
              onTap: gallery!,
              children: [
                Image.asset(
                  IconConstant.instance.picture,
                  width: context.getWidth(24),
                  height: context.getHeight(24),
                ),
                SizedBox(width: context.getWidth(15)),
                Text(
                  StringConstant.gallery,
                  style: AppFonts().titleLarge.copyWith(color: AppColors.black),
                )
              ],
            ),
            SizedBox(height: context.getHeight(15)),
            BottomSheetButton(
              onTap: () {
                Navigator.pop(context);
              },
              children: [
                Text(
                  StringConstant.cancel,
                  style: AppFonts().titleLarge.copyWith(color: AppColors.blue),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
