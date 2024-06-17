// lib/services/achievement_service_impl.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_app/models/achievement/achievement_model.dart';
import 'package:test_app/services/achievement/iachievement_service.dart';

class AchievementService implements IAchievementService {
  @override
  Future<List<AchievementModel>> fetchAchievements(String kidId, String token) async {
    final response = await http.get(
      Uri.parse('https://kiddo-api-production.up.railway.app/api/guests/$kidId/achievements'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => AchievementModel.fromJson(json)).toList();
    } else {
      final jsonResponse = json.decode(response.body);
      throw Exception(jsonResponse['message']);
    }
  }
}
