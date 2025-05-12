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

  Future<void> initialize() async {
    final accessToken = await _storageService.readSecureData('access_token');
    final refreshToken = await _storageService.readSecureData('refresh_token');

    if (accessToken != null && refreshToken != null) {
      try {
        _user = await _apiService.fetchUserProfile(accessToken, refreshToken);
        notifyListeners();
      } catch (e) {
        debugPrint('⚠️ Failed to restore session: $e');
        await _storageService.clearAuthData();
      }
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _apiService.login(email, password);
      await _storageService.saveAuthData(_user!);
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
      await _storageService.saveAuthData(_user!);
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

  Future<bool> refreshAccessToken() async {
    final newToken = await _apiService.refreshAccessToken();
    if (newToken != null) {
      _user = await _apiService.fetchUserProfile(
        newToken,
        await _storageService.readSecureData('refresh_token') ?? '',
      );
      notifyListeners();
      return true;
    } else {
      _user = null;
      await _storageService.clearAuthData();
      notifyListeners();
      return false;
    }
  }

  static void setupDioInterceptor(Dio dio, AuthProvider authProvider) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await authProvider._storageService.readSecureData(
            'access_token',
          );
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            final success = await authProvider.refreshAccessToken();
            if (success) {
              final newToken = await authProvider._storageService
                  .readSecureData('access_token');
              final options = error.requestOptions;
              options.headers['Authorization'] = 'Bearer $newToken';

              // Retry the failed request
              try {
                final clonedRequest = await dio.fetch(options);
                return handler.resolve(clonedRequest);
              } catch (e) {
                debugPrint('❌ Retried request failed: $e');
              }
            } else {
              debugPrint('❌ Token refresh failed. Logging out.');
              await authProvider.logout();
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
