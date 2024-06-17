import 'package:flutter/material.dart';
import 'package:test_app/models/profile/profile_model.dart';

abstract class IProfileViewModel with ChangeNotifier {
  ProfileModel? get profile;
  bool get isLoading;
  String get errorMessage;

  Future<void> fetchProfile();
}
