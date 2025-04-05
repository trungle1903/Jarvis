import 'package:flutter/foundation.dart';
import 'package:jarvis/services/storage.dart';
import '../models/user.dart';
import '../services/api/auth_api_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthApiService _apiService = AuthApiService();
  final StorageService _storageService = StorageService();
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _apiService.login(email, password);
      _error = null;
    } catch (e) {
      _user = null;
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _apiService.register(name, email, password);
      _error = null;
    } catch (e) {
      _user = null;
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.logout();
      _user = null;
      _error = null;
      await _storageService.clearAuthData();
    } catch (e) {
      debugPrint('Logout error: $e');
      _error = 'Logout failed';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
