import 'package:meta/meta.dart';

class SignupValidationResult {
  final String name;
  final String email;
  final String password;
  final bool success;
  final String error;

  SignupValidationResult({
    @required this.name,
    @required this.email,
    @required this.password,
    this.success: false,
    this.error,
  });
}
