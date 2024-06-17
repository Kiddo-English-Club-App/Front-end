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