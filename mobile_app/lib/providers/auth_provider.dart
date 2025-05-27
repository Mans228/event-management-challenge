import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService;
  User? _currentUser;
  bool _isLoading = false;

  AuthProvider(this._apiService);

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;

  Future<void> register(String email, String username) async {
    _currentUser = await _apiService.register(email, username);
    notifyListeners();
  }

  Future<void> login(int userId) async {
    _currentUser = await _apiService.login(userId);
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  Future<void> refreshUserProfile() async {
    if (!isAuthenticated) return;

    try {
      _currentUser = await _apiService.getCurrentUser();
      notifyListeners();
    } catch (e) {
      // Handle error or token expiration
      logout();
    }
  }
}
