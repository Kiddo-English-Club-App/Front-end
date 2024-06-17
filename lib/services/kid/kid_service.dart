import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/models/kid/kid_model.dart';
import 'dart:convert';

import 'package:test_app/services/kid/ikid_service.dart';
import 'package:test_app/views/global_utilities/global_variables.dart';

class KidService implements IKidService {
  final _secureStorage = FlutterSecureStorage();
  final _url = 'https://kiddo-api-production.up.railway.app/api/guests/';

  @override
  Future<List<KidModel>> fetchKids() async {
    String? accessToken = await _secureStorage.read(key: 'access_token');
    if (accessToken == null) {
      throw Exception('Access token is not available');
    }

    final response = await http.get(Uri.parse(_url), headers: {
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => KidModel.fromJson(json)).toList();
    } else {
      throw Exception('Error fetching data: ${response.statusCode}');
    }
  }

  @override
  Future<void> storeKidId(String kidId) async {
    GlobalVariables.guestId = kidId;
    await _secureStorage.write(key: 'kid_id', value: kidId);
  }

  @override
  Future<String?> getKidId() async {
    return await _secureStorage.read(key: 'kid_id');
  }
}
