
import 'package:test_app/models/profile/profile_model.dart';

abstract class IProfileService {
  Future<ProfileModel> fetchProfile(String token);
}
