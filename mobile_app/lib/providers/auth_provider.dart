import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLogin = true;
  bool get isLogin => _isLogin;

  void toggleFormMode() {
    _isLogin = !_isLogin;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

// Add login and register logic later
}
