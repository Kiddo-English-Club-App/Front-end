import 'package:test_app/models/register/register_response_model.dart';

abstract class IRegisterService {
  Future<RegisterResponseModel> register(String firstName, String lastName, String email, String password);
}
