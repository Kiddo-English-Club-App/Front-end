// lib/viewmodels/iregister_viewmodel.dart
import 'package:flutter/material.dart';

abstract class IRegisterViewModel with ChangeNotifier {
  bool get isLoading;
  String get errorMessage;

  Future<void> register(BuildContext context, String firstName, String lastName, String email, String password);
}
