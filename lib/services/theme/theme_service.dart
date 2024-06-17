import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/utility/secure_storage_helper.dart';

class ThemeVocabulary {
  final String id;
  final String name;
  final String description;
  final String background;
  final String image;
  final List<Item> items;

  ThemeVocabulary({
    required this.id,
    required this.name,
    required this.description,
    required this.background,
    required this.image,
    required this.items,
  });

  factory ThemeVocabulary.fromJson(Map<String, dynamic> json) {
    return ThemeVocabulary(
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

class ThemeService with ChangeNotifier {
  List<ThemeVocabulary> _themes = [];
  ThemeVocabulary? _selectedTheme;
  bool _isLoading = false;
  String _errorMessage = '';

  List<ThemeVocabulary> get themes => _themes;
  ThemeVocabulary? get selectedTheme => _selectedTheme;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

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
      if (response.statusCode != 200) {
        _errorMessage = 'Failed to load themes';
        notifyListeners();
        return;
      }
      final jsonResponse = json.decode(response.body);
      final List<ThemeVocabulary> themes = (jsonResponse as List)
          .map((themeJson) => ThemeVocabulary.fromJson(themeJson))
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

  Future<void> fetchThemeById(String themeId) async {
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
        Uri.parse('https://kiddo-api-production.up.railway.app/api/themes/$themeId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      print('Status code:');
      print(response.statusCode);

      if (response.statusCode != 200) {
        _errorMessage = 'Failed to load theme';
        notifyListeners();
        return;
      }

      final jsonResponse = json.decode(response.body);
      _selectedTheme = ThemeVocabulary.fromJson(jsonResponse);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load theme';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
