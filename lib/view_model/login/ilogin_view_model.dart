// lib/viewmodels/ilogin_viewmodel.dart
import 'package:flutter/material.dart';

abstract class ILoginViewModel with ChangeNotifier {
  bool get isLoading;
  String get errorMessage;

  Future<void> login(BuildContext context, String email, String password);
}
