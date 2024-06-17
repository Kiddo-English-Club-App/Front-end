import 'package:flutter/material.dart';
import 'package:test_app/services/register/iregister_service.dart';
import 'package:test_app/view_model/register/iregister_view_model.dart';
import 'package:test_app/views/intial_screens/interfaces/login/login.dart';

class RegisterViewModel extends IRegisterViewModel {
  final IRegisterService _registerService;

  RegisterViewModel(this._registerService);

  bool _isLoading = false;
  String _errorMessage = '';

  @override
  bool get isLoading => _isLoading;

  @override
  String get errorMessage => _errorMessage;

  @override
  Future<void> register(BuildContext context, String firstName, String lastName, String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _registerService.register(firstName, lastName, email, password);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
