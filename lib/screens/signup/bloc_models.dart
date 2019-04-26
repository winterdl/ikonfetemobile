import 'package:ikonfete/model/sex.dart';
import 'package:meta/meta.dart';

class SignupValidationResult {
  final String name;
  final String email;
  final String password;
  final Sex sex;
  final bool success;
  final String error;

  SignupValidationResult({
    @required this.name,
    @required this.email,
    @required this.password,
    @required this.sex,
    this.success: false,
    this.error,
  });
}
