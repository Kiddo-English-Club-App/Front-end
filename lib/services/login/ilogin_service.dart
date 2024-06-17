import 'package:test_app/models/login/login_response_model.dart';

abstract class ILoginService {
  Future<LoginResponseModel> login(String email, String password);
}
