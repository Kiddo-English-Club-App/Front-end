import 'package:test_app/models/report/report_model.dart';

class Theme {
  final String id;
  final String name;
  final String description;
  final String background;
  final String image;
  final List<Item> items;

  Theme({
    required this.id,
    required this.name,
    required this.description,
    required this.background,
    required this.image,
    required this.items,
  });

  // Factory method to create a Theme instance from JSON
  factory Theme.fromJson(Map<String, dynamic> json) {
    return Theme(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      background: json['background'],
      image: json['image'], // No transformation, exact as provided by API
      items: (json['items'] as List)
          .map((itemJson) => Item.fromJson(itemJson))
          .toList(),
    );
  }
}

