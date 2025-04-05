import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jarvis/services/header_service.dart';
import 'package:jarvis/services/storage.dart';
import '../models/user.dart';
import '../services/api/auth_api_service.dart';

class AuthProvider with ChangeNotifier {
  final StorageService _storageService;
  final HeaderService _headerService;
  final AuthApiService _apiService;
  User? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider({
    required StorageService storageService,
    required HeaderService headerService,
    required Dio dio,
  }) : _storageService = storageService,
       _headerService = headerService,
       _apiService = AuthApiService(headerService, dio);
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

  Future<void> register(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _apiService.register(email, password);
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
