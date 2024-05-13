import 'dart:async';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phonebook/core/constants/api_constant.dart';
import 'package:phonebook/models/contact_request.dart';
import 'package:phonebook/models/response_model.dart';

import 'dio_manager_service.dart';

class ContactService {
  final DioManager _dioManager = DioManager();

  Future<ResponseModel> createContact(ContactRequest contactData) async {
    final response = await _dioManager.post(ApiConstant.postUser, data: contactData.toJson());

    return ResponseModel.fromJson(response);
  }

  Future<ResponseModel> getContactList() async {
    final response = await _dioManager.get(ApiConstant.getUserList, queryParameters: {"take": 100000});

    return ResponseModel.fromJson(response);
  }

  Future<ResponseModel> getContact(String contactID) async {
    final response = await _dioManager.get('${ApiConstant.getUser}$contactID');

    return ResponseModel.fromJson(response);
  }

  Future<ResponseModel> updateContact(String contactID, ContactRequest contactData) async {
    final response = await _dioManager.put('${ApiConstant.putUser}$contactID', data: contactData.toJson());

    return ResponseModel.fromJson(response);
  }

  Future<ResponseModel> deleteContact(String contactID) async {
    final response = await _dioManager.delete('${ApiConstant.deleteUser}$contactID');

    return ResponseModel.fromJson(response);
  }

  Future<ResponseModel> uploadImage(XFile pickedFile) async {
    var formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(pickedFile.path, filename: pickedFile.name),
    });

    final response = await _dioManager.post(ApiConstant.postUserImage, data: formData, headers: {
      'Content-Type': 'multipart/form-data',
    });

    return ResponseModel.fromJson(response);
  }
}
