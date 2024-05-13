// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phonebook/core/app_enums.dart';
import 'package:phonebook/core/constants/icon_constant.dart';
import 'package:phonebook/core/theme/app_colors.dart';
import 'package:phonebook/core/theme/app_fonts.dart';
import 'package:phonebook/models/contact_response.dart';
import 'package:phonebook/util/responsive_extensions.dart';
import 'package:phonebook/widgets/app_bottom_sheet.dart';
import 'package:phonebook/widgets/app_snack_bar.dart';
import 'package:phonebook/widgets/contact_text.dart';
import 'package:phonebook/widgets/contact_text_form_field.dart';
import 'package:provider/provider.dart';

import '../app_provider.dart';
import '../core/constants/string_constant.dart';
import '../models/contact_request.dart';
import '../services/contact_service.dart';
import '../services/locator/app_service_locator.dart';
import '../widgets/cached_image.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key, this.contact});

  final ContactResponse? contact;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final contactService = AppServiceLocator().get<ContactService>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      firstNameController.text = widget.contact!.firstName!;
      lastNameController.text = widget.contact!.lastName!;
      phoneNumberController.text = widget.contact!.phoneNumber!;
    }
  }

  void checkDataStatus() {
    if (widget.contact == null) {
      if (firstNameController.text.trim() != '' && lastNameController.text.trim() != '' && phoneNumberController.text.trim() != '' && context.read<AppProvider>().imageUrl != null) {
        context.read<AppProvider>().setDataStatus(DataStatus.done);
      } else {
        context.read<AppProvider>().setDataStatus(DataStatus.create);
      }
    } else {
      if (firstNameController.text.trim() == widget.contact!.firstName &&
          lastNameController.text.trim() == widget.contact!.lastName &&
          phoneNumberController.text.trim() == widget.contact!.phoneNumber &&
          context.read<AppProvider>().imageUrl! == widget.contact!.profileImageUrl) {
        context.read<AppProvider>().setDataStatus(DataStatus.create);
      } else {
        context.read<AppProvider>().setDataStatus(DataStatus.done);
      }
    }
  }

  Future<void> pickImage(ImageSource source) async {
    await ImagePicker().pickImage(source: source).then((pickedFile) async {
      if (pickedFile == null) {
        return;
      }
      context.read<AppProvider>().setPickedFile(pickedFile);
      final documentsDir = await getApplicationDocumentsDirectory();
      compressAndGetFile(File(pickedFile.path), '${documentsDir.path}compressed_image.jpg').then(
        (compress) => contactService
            .uploadImage(compress!)
            .then(
              (value) => context.read<AppProvider>().setImageUrl(value.data!.imageUrl!),
            )
            .then(
              (value) => checkDataStatus(),
            ),
      );
    });
  }

  Future<XFile?> compressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      minHeight: 200,
      minWidth: 200,
      quality: 75,
    );

    return result;
  }

  void contactTransactions(BuildContext context) {
    switch (context.read<AppProvider>().dataStatus) {
      case DataStatus.create:
        break;
      case DataStatus.edit:
        context.read<AppProvider>().setDataStatus(DataStatus.create);

        break;
      case DataStatus.done:
        context.read<AppProvider>().setDataStatus(DataStatus.edit);
        if (widget.contact == null) {
          contactService.createContact(getContactRequest()).then((value) {
            if (value.status == 200) {
              servicesSucces(context, StringConstant.contactCreated);
            }
          });
        } else {
          contactService.updateContact(widget.contact!.id!, getContactRequest()).then((value) {
            if (value.status == 200) {
              servicesSucces(context, StringConstant.contactUpdated);
            }
          });
        }
        break;
      default:
    }
  }

  ContactRequest getContactRequest() => ContactRequest(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        phoneNumber: phoneNumberController.text.trim(),
        profileImageUrl: context.read<AppProvider>().imageUrl!,
      );

  void servicesSucces(BuildContext context, String message) {
    context.read<AppProvider>().setIsRefresh(true);
    context.read<AppProvider>().setSnackBarMessage(message);
    context.read<AppProvider>().setShowSnackBar(true);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Scaffold(
          body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(context.getPadding(17.5)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: context.getHeight(75),
                  ),
                  widget.contact?.profileImageUrl == null && context.read<AppProvider>().pickedFile == null
                      ? Container(
                          width: context.getWidth(195),
                          height: context.getHeight(195),
                          decoration: ShapeDecoration(
                            image: context.read<AppProvider>().pickedFile == null
                                ? DecorationImage(image: AssetImage(IconConstant.instance.contact), fit: BoxFit.fill)
                                : DecorationImage(image: FileImage(File(context.read<AppProvider>().pickedFile!.path)), fit: BoxFit.fill),
                            shape: const CircleBorder(),
                          ),
                        )
                      : context.read<AppProvider>().pickedFile == null
                          ? CachedImage(profileImageUrl: widget.contact!.profileImageUrl!, size: 195.0)
                          : Container(
                              width: context.getWidth(195),
                              height: context.getHeight(195),
                              decoration: ShapeDecoration(
                                image: DecorationImage(image: FileImage(File(context.read<AppProvider>().pickedFile!.path)), fit: BoxFit.fill),
                                shape: const CircleBorder(),
                              ),
                            ),
                  SizedBox(
                    height: context.getHeight(15),
                  ),
                  TextButton(
                    onPressed: () {
                      AppBottomSheet().showImage(
                        context,
                        camera: () => pickImage(ImageSource.camera).then((value) => Navigator.pop(context)),
                        gallery: () => pickImage(ImageSource.gallery).then((value) => Navigator.pop(context)),
                      );
                    },
                    child: Text(
                      widget.contact == null ? StringConstant.addPhoto : StringConstant.changePhoto,
                      style: AppFonts().bodyLarge.copyWith(
                            color: AppColors.black,
                          ),
                    ),
                  ),
                  context.watch<AppProvider>().dataStatus != DataStatus.edit
                      ? Column(
                          children: [
                            ContactTextFormField(
                              controller: firstNameController,
                              keyboardType: TextInputType.text,
                              hintText: StringConstant.firstName,
                              onChanged: (value) => checkDataStatus(),
                            ),
                            ContactTextFormField(
                              controller: lastNameController,
                              keyboardType: TextInputType.text,
                              hintText: StringConstant.lastName,
                              onChanged: (value) => checkDataStatus(),
                            ),
                            ContactTextFormField(
                              controller: phoneNumberController,
                              keyboardType: TextInputType.phone,
                              hintText: StringConstant.phoneNumber,
                              onChanged: (value) => checkDataStatus(),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            ContactText(text: firstNameController.text),
                            ContactText(text: lastNameController.text),
                            ContactText(text: phoneNumberController.text),
                          ],
                        ),
                  Visibility(
                    visible: context.watch<AppProvider>().dataStatus == DataStatus.edit,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: TextButton(
                          onPressed: () {
                            AppBottomSheet().showDeleteAccount(context, widget.contact!.id!);
                          },
                          child: Text(
                            StringConstant.deleteContact,
                            style: AppFonts().bodyLarge.copyWith(
                                  color: AppColors.redDeleteAccount,
                                ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.all(context.getPadding(17.5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      StringConstant.cancel,
                      style: AppFonts().bodySmall.copyWith(
                            color: AppColors.blue,
                          ),
                    ),
                  ),
                  Visibility(
                    visible: widget.contact == null,
                    child: Text(
                      StringConstant.newContact,
                      style: AppFonts().bodyLarge.copyWith(color: AppColors.black),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      contactTransactions(context);
                    },
                    child: Text(
                      context.watch<AppProvider>().dataStatus != DataStatus.edit ? StringConstant.done : StringConstant.edit,
                      style: AppFonts().bodyLarge.copyWith(
                            color: context.watch<AppProvider>().dataStatus == DataStatus.create ? AppColors.grey : AppColors.blue,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: context.watch<AppProvider>().showSnackBar,
            child: const Align(
              alignment: Alignment.bottomCenter,
              child: AppSnackBar(),
            ),
          )
        ],
      )),
    );
  }
}
