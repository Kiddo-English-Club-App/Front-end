// lib/models/report.dart

class ReportModel {
  final String guestId;
  final double avgPoints;
  final double avgTime;
  final List<Score> topScores;
  final List<Score> bottomScores;

  ReportModel({
    required this.guestId,
    required this.avgPoints,
    required this.avgTime,
    required this.topScores,
    required this.bottomScores,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    var topScoresFromJson = json['top_scores'] as List;
    var bottomScoresFromJson = json['bottom_scores'] as List;

    List<Score> topScoresList = topScoresFromJson.map((score) => Score.fromJson(score)).toList();
    List<Score> bottomScoresList = bottomScoresFromJson.map((score) => Score.fromJson(score)).toList();

    return ReportModel(
      guestId: json['guest_id'],
      avgPoints: json['avg_points'],
      avgTime: json['avg_time'],
      topScores: topScoresList,
      bottomScores: bottomScoresList,
    );
  }
}
class Score {
  final String themeName;
  final double points;
  final double time;
  final int elements;

  Score({
    required this.themeName,
    required this.points,
    required this.time,
    required this.elements,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      themeName: json['theme_name'],
      points: json['points'],
      time: json['time'],
      elements: json['elements'],
    );
  }
}

class Item {
  final String id;
  final String name;
  final String image;
  final String sound;

  Item({
    required this.id,
    required this.name,
    required this.image,
    required this.sound,
  });

  // Factory method to create an Item instance from JSON
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      sound: json['sound'],
    );
  }
}