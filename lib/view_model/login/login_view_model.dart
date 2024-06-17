// lib/viewmodels/login_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:test_app/services/login/ilogin_service.dart';
import 'package:test_app/view_model/login/ilogin_view_model.dart';
import 'package:test_app/views/intial_screens/interfaces/user/select_user_screen.dart';

class LoginViewModel extends ILoginViewModel {
  final ILoginService _loginService;

  LoginViewModel(this._loginService);

  bool _isLoading = false;
  String _errorMessage = '';

  @override
  bool get isLoading => _isLoading;

  @override
  String get errorMessage => _errorMessage;

  @override
  Future<void> login(BuildContext context, String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _loginService.login(email, password);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => UserScreen()),//redirección de la página principal
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
