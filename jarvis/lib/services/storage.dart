import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jarvis/models/user.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();

  static const androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
    keyCipherAlgorithm:
        KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
    storageCipherAlgorithm: StorageCipherAlgorithm.AES_CBC_PKCS7Padding,
  );

  static const iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  Future<void> writeSecureData(String key, String value) async {
    await _storage.write(
      key: key,
      value: value,
      iOptions: iosOptions,
      aOptions: androidOptions,
    );
  }

  Future<String?> readSecureData(String key) async {
    return await _storage.read(
      key: key,
      iOptions: iosOptions,
      aOptions: androidOptions,
    );
  }

  Future<void> deleteSecureData(String key) async {
    await _storage.delete(
      key: key,
      iOptions: iosOptions,
      aOptions: androidOptions,
    );
  }

  Future<void> clearAll() async {
    await _storage.deleteAll(iOptions: iosOptions, aOptions: androidOptions);
  }

  Future<void> saveAuthData(User user) async {
    await StorageService().writeSecureData('access_token', user.token!);
    await StorageService().writeSecureData('refresh_token', user.refreshToken!);
    await StorageService().writeSecureData('user_id', user.id);
  }

  Future<User?> getStoredUser() async {
    final accessToken = await StorageService().readSecureData('access_token');
    final refreshToken = await StorageService().readSecureData('refresh_token');
    final userId = await StorageService().readSecureData('user_id');

    if (accessToken == null) return null;

    return User(
      id: userId ?? '0',
      name: '', // Retrieve from storage if needed
      email: '', // Retrieve from storage if needed
      token: accessToken,
      refreshToken: refreshToken,
    );
  }

  Future<void> clearAuthData() async {
    await StorageService().deleteSecureData('access_token');
    await StorageService().deleteSecureData('refresh_token');
    await StorageService().deleteSecureData('user_id');
  }
}
