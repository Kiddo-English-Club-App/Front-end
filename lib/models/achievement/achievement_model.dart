// lib/models/achievement.dart
class AchievementModel {
  final String id;
  final double value;
  final String theme;
  final String message;

  AchievementModel({
    required this.id,
    required this.value,
    required this.theme,
    required this.message,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'],
      value: json['value'],
      theme: json['theme'],
      message: json['message'],
    );
  }
}
