import 'dart:async';

import 'package:flutter/material.dart';
import 'package:phonebook/core/app_enums.dart';
import 'package:phonebook/core/constants/icon_constant.dart';
import 'package:phonebook/core/theme/app_colors.dart';
import 'package:phonebook/core/theme/app_fonts.dart';
import 'package:phonebook/models/contact_response.dart';
import 'package:phonebook/pages/profile_view.dart';
import 'package:phonebook/services/contact_service.dart';
import 'package:phonebook/util/responsive_extensions.dart';
import 'package:provider/provider.dart';

import '../app_provider.dart';
import '../core/constants/string_constant.dart';
import '../services/locator/app_service_locator.dart';
import '../widgets/app_snack_bar.dart';
import '../widgets/cached_image.dart';

class ContactsView extends StatefulWidget {
  const ContactsView({super.key});

  @override
  State<ContactsView> createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  TextEditingController searchController = TextEditingController();
  final contactService = AppServiceLocator().get<ContactService>();
  final contactsStreamController = StreamController<List<ContactResponse>>();

  @override
  void dispose() {
    super.dispose();
    contactsStreamController.close();
  }

  @override
  void initState() {
    super.initState();
    contactService.getContactList().then((contacts) {
      contactsStreamController.add(contacts.data?.users as List<ContactResponse>);
      context.read<AppProvider>().setContacts(contacts.data?.users as List<ContactResponse>);
    });
  }

  Stream<List<ContactResponse>> get contactsStream => contactsStreamController.stream;

  void searchContacts(String searchQuery) {
    final contacts = context.read<AppProvider>().contacts;
    if (searchQuery.isEmpty) {
      contactsStreamController.add(contacts);
    }
    contactsStreamController.add(contacts.where((contact) => (contact.firstName!.toLowerCase()).contains(searchQuery.toLowerCase())).toList());
  }

  Column noContactsBody(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Image.asset(
          IconConstant.instance.contact,
          width: context.getWidth(60),
          height: context.getHeight(60),
        ),
        SizedBox(height: context.getHeight(15)),
        Text(
          StringConstant.noContacts,
          style: AppFonts().titleLarge.copyWith(color: AppColors.black),
        ),
        SizedBox(height: context.getHeight(7)),
        Text(
          StringConstant.addContact,
          style: AppFonts().bodyLarge.copyWith(color: AppColors.black),
        ),
        SizedBox(height: context.getHeight(7)),
        TextButton(
          onPressed: () {
            openProfile(context, status: DataStatus.create);
          },
          child: Text(
            StringConstant.createContact,
            style: AppFonts().bodyLarge.copyWith(color: AppColors.blue),
          ),
        ),
        const Spacer()
      ],
    );
  }

  void openProfile(BuildContext context, {ContactResponse? contact, DataStatus? status}) {
    if (status != null) context.read<AppProvider>().setDataStatus(status);
    searchController.clear();
    FocusScope.of(context).unfocus();
    searchContacts('');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      constraints: BoxConstraints(
        maxHeight: context.height * 0.9,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (context) => ProfileView(contact: contact),
    ).then((value) {
      if (context.read<AppProvider>().isRefresh) {
        ContactService().getContactList().then((contacts) {
          context.read<AppProvider>().setIsRefresh(false);
          contactsStreamController.add(contacts.data?.users as List<ContactResponse>);
          context.read<AppProvider>().setContacts(contacts.data?.users as List<ContactResponse>);
        });
      }
      context.read<AppProvider>().setPickedFile(null);
      context.read<AppProvider>().setImageUrl(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.pageColor,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(context.getPadding(30), context.getPadding(50), context.getPadding(30), 0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        StringConstant.contacts,
                        style: AppFonts().titleLarge.copyWith(color: AppColors.black),
                      ),
                      InkWell(
                        child: Image.asset(
                          IconConstant.instance.add,
                          width: context.getWidth(24),
                          height: context.getHeight(24),
                        ),
                        onTap: () {
                          openProfile(context, status: DataStatus.create);
                        },
                      )
                    ],
                  ),
                  Container(
                    height: context.getHeight(40),
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      top: context.getMargin(15),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: StringConstant.search,
                        hintStyle: AppFonts().bodyLarge.copyWith(color: AppColors.grey),
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.grey,
                          size: context.getIconSize(21),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: context.getPadding(12),
                        ),
                      ),
                      onChanged: searchContacts,
                    ),
                  ),
                  StreamBuilder<List<ContactResponse>>(
                    stream: contactsStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Expanded(child: Center(child: CircularProgressIndicator()));
                      }

                      if (snapshot.data!.isEmpty) {
                        return Expanded(child: noContactsBody(context));
                      }

                      final contacts = snapshot.data!;

                      return Expanded(
                        child: ListView.builder(
                          itemCount: contacts.length,
                          itemBuilder: (context, index) {
                            final contact = contacts[index];
                            return GestureDetector(
                              onTap: () {
                                context.read<AppProvider>().setImageUrl(contact.profileImageUrl!);
                                openProfile(context, contact: contact, status: DataStatus.edit);
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: context.getMargin(20)),
                                padding: EdgeInsets.symmetric(horizontal: context.getPadding(20)),
                                height: context.getHeight(70),
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    CachedImage(profileImageUrl: contact.profileImageUrl!, size: 34.0),
                                    SizedBox(width: context.getWidth(10)),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${contact.firstName} ${contact.lastName}\n',
                                            style: AppFonts().bodyLarge.copyWith(color: AppColors.black),
                                          ),
                                          TextSpan(
                                            text: contact.phoneNumber,
                                            style: AppFonts().bodyLarge.copyWith(color: AppColors.grey),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  )
                ],
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
        ),
      ),
    );
  }
}
