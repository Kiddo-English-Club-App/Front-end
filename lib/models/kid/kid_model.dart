class KidModel {
  final String id;
  final String name;
  final String host;
  final String image;

  KidModel({required this.id, required this.name, required this.host, required this.image});

  factory KidModel.fromJson(Map<String, dynamic> json) {
    return KidModel(
      id: json['id'],
      name: json['name'],
      host: json['host'],
      image: json['image'],
    );
  }
}
