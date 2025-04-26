import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jarvis/constants/api_headers.dart';

class HeaderService {
  static Future<HeaderService> initialize() async {
    await dotenv.load(fileName: '.env');
    return HeaderService._internal();
  }

  HeaderService._internal();

  String get _projectId => dotenv.get('PROJECT_ID');
  String get _clientKey => dotenv.get('CLIENT_KEY');

  Map<String, String> get baseHeaders {
    return {
      ApiHeader.contentType.value: 'application/json',
      ApiHeader.stackAccessType.value: 'client',
      ApiHeader.stackProjectId.value: _projectId,
      ApiHeader.stackClientKey.value: _clientKey,
    };
  }

  Map<String, String> withAuth(String token) {
    return {...baseHeaders, 'Authorization': 'Bearer $token'};
  }
}
