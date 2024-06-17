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