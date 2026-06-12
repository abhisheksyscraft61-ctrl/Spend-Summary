import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../core/services/mock_data_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  void loadUser() {
    _user = MockDataService.currentUser;
    notifyListeners();
  }
}
