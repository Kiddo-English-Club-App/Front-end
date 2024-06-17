// lib/models/register_response.dart
class RegisterResponseModel {
  final String message;

  RegisterResponseModel.RegisterResponse({required this.message});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel.RegisterResponse(
      message: json['message'],
    );
  }
}
