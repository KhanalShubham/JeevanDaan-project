import 'package:flutter/material.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';

class UserNotifier extends ChangeNotifier {
  UserEntity? _user;

  UserEntity? get user => _user;

  void setUser(UserEntity user) {
    _user = user;
    notifyListeners();
  }

  void updateName(String name) {
    if (_user != null) {
      _user = _user!.copyWith(name: name);
      notifyListeners();
    }
  }

  void updateContact(String contact) {
    if (_user != null) {
      _user = _user!.copyWith(contact: contact);
      notifyListeners();
    }
  }

  void updateDisease(String disease) {
    if (_user != null) {
      _user = _user!.copyWith(disease: disease);
      notifyListeners();
    }
  }

  void updateDescription(String description) {
    if (_user != null) {
      _user = _user!.copyWith(description: description);
      notifyListeners();
    }
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
