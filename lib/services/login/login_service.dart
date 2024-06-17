// lib/services/login_service_impl.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_app/models/login/login_response_model.dart';
import 'package:test_app/services/login/ilogin_service.dart';
import 'package:test_app/utility/secure_storage_helper.dart';

class LoginService implements ILoginService {
  final SecureStorageHelper _secureStorageHelper = SecureStorageHelper();

  @override
  Future<LoginResponseModel> login(String email, String password) async {
    final requestBody = json.encode({
      'email': email,
      'password': password,
    });

    final requestUrl = Uri.parse('https://kiddo-api-production.up.railway.app/api/accounts/login');

    final response = await http.post(
      requestUrl,
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final loginResponse = LoginResponseModel.fromJson(jsonResponse);
      await _secureStorageHelper.storeValue('access_token', loginResponse.accessToken);
      return loginResponse;
    } else {
      final jsonResponse = json.decode(response.body);
      throw Exception(jsonResponse['message']);
    }
  }
}
