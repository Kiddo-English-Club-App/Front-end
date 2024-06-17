// lib/services/achievement_service.dart

import 'package:test_app/models/achievement/achievement_model.dart';

abstract class IAchievementService {
  Future<List<AchievementModel>> fetchAchievements(String kidId, String token);
}
