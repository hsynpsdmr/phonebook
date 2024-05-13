import 'package:flutter/material.dart';
import 'package:phonebook/app_provider.dart';
import 'package:phonebook/pages/contacts_view.dart';
import 'package:phonebook/services/contact_service.dart';
import 'package:phonebook/services/locator/app_service_locator.dart';
import 'package:provider/provider.dart';

import 'core/constants/string_constant.dart';

void main() {
  AppServiceLocator().register<ContactService>(ContactService());
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: StringConstant.appName,
      home: ContactsView(),
    );
  }
}
