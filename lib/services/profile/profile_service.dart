// lib/services/profile_service_impl.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_app/models/profile/profile_model.dart';
import 'package:test_app/services/profile/interface_profile_service.dart';

class ProfileService implements IProfileService {
  @override
  Future<ProfileModel> fetchProfile(String token) async {
    final response = await http.get(
      Uri.parse('https://kiddo-api-production.up.railway.app/api/accounts/profile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print('Statuws code:');
    print(response.statusCode);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ProfileModel.fromJson(data);
    } else {
      final jsonResponse = json.decode(response.body);
      throw Exception(jsonResponse['message']);
    }
  }
}
