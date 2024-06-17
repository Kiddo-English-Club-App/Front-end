// lib/services/register_service_impl.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_app/models/register/register_response_model.dart';
import 'package:test_app/services/register/iregister_service.dart';

class RegisterService implements IRegisterService {
  @override
  Future<RegisterResponseModel> register(String firstName, String lastName, String email, String password) async {
    final response = await http.post(
      Uri.parse('https://kiddo-api-production.up.railway.app/api/accounts/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return RegisterResponseModel.fromJson(jsonResponse);
    } else {
      final jsonResponse = json.decode(response.body);
      throw Exception(jsonResponse['message']);
    }
  }
}
