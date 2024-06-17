import 'package:flutter/material.dart';
import 'package:test_app/models/achievement/achievement_model.dart';

abstract class IAchievementViewModel with ChangeNotifier {
  List<AchievementModel> get achievements;
  bool get isLoading;
  String get errorMessage;

  Future<void> fetchAchievements();
}
