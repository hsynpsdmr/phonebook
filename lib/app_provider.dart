import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phonebook/core/app_enums.dart';
import 'package:phonebook/models/contact_response.dart';

class AppProvider extends ChangeNotifier {
  List<ContactResponse> _contacts = [];
  DataStatus? _dataStatus;
  String? _imageUrl;
  bool _isRefresh = false;
  XFile? _pickedFile;
  bool _showSnackBar = false;
  String _snackBarMessage = '';

  XFile? get pickedFile => _pickedFile;

  void setPickedFile(XFile? file) {
    _pickedFile = file;
    notifyListeners();
  }

  String? get imageUrl => _imageUrl;

  void setImageUrl(String? url) {
    _imageUrl = url;
    notifyListeners();
  }

  DataStatus? get dataStatus => _dataStatus;

  void setDataStatus(DataStatus status) {
    _dataStatus = status;
    notifyListeners();
  }

  bool get showSnackBar => _showSnackBar;

  void setShowSnackBar(bool show) {
    _showSnackBar = show;
    notifyListeners();
  }

  String get snackBarMessage => _snackBarMessage;

  void setSnackBarMessage(String message) {
    _snackBarMessage = message;
    notifyListeners();
  }

  List<ContactResponse> get contacts => _contacts;

  void setContacts(List<ContactResponse> contacts) {
    _contacts = contacts;
    notifyListeners();
  }

  bool get isRefresh => _isRefresh;

  void setIsRefresh(bool refresh) {
    _isRefresh = refresh;
    notifyListeners();
  }
}
