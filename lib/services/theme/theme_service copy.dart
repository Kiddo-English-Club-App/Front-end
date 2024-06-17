import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:test_app/utility/secure_storage_helper.dart';

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

  factory Theme.fromJson(Map<String, dynamic> json) {
    return Theme(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      background: json['background'],
      image: json['image'],
      items: (json['items'] as List)
          .map((itemJson) => Item.fromJson(itemJson))
          .toList(),
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

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      sound: json['sound'],
    );
  }
}

class ThemeServiceTest with ChangeNotifier {
  List<Theme> _themes = [];
  bool _isLoading = false;
  String _errorMessage = '';
  List<Map<String, dynamic>> _cardDataList = [];

  List<Theme> get themes => _themes;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get cardDataList => _cardDataList;

  Future<void> fetchThemes() async {
    _isLoading = true;
    notifyListeners();

    try {
      final accessToken = await SecureStorageHelper().getValue('access_token');
      if (accessToken.isEmpty) {
        _errorMessage = 'Access token not found';
        notifyListeners();
        return;
      }

      final response = await http.get(
        Uri.parse('https://kiddo-api-production.up.railway.app/api/themes/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      print('Status code:');
      print(response.statusCode);

      if (response.statusCode != 200) {
        _errorMessage = 'Failed to load themes $response.statusCode';
        notifyListeners();
        return;
      }

      final jsonResponse = json.decode(response.body);
      _cardDataList = List<Map<String, dynamic>>.from(jsonResponse);
      final List<Theme> themes = (jsonResponse as List)
          .map((themeJson) => Theme.fromJson(themeJson))
          .toList();
      _themes = themes;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load themes';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeServiceTest()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ThemeListScreen(),
    );
  }
}

class ThemeListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Themes')),
      body: Consumer<ThemeServiceTest>(
        builder: (context, themeService, child) {
          if (themeService.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (themeService.errorMessage.isNotEmpty) {
            return Center(child: Text(themeService.errorMessage));
          }
          return ListView.builder(
            itemCount: themeService.themes.length,
            itemBuilder: (context, index) {
              final theme = themeService.themes[index];
              return ListTile(
                title: Text(theme.name),
                subtitle: Text(theme.description),
              );
            },
          );
        },
      ),
    );
  }
}
