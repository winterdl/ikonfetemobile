import 'dart:io';

import 'package:ikonfete/model/user.dart';
import 'package:meta/meta.dart';

class SignupResult {
  final bool success;
  final String error;
  final String uid;

  SignupResult({@required this.success, this.error, this.uid});
}

class EmailValidationResult {
  bool isValid;
  String error;

  EmailValidationResult(this.isValid, this.error);
}

class SignupData {
  final User user;
  final String password;
  File profilePicture;

  SignupData(this.user, this.password, {this.profilePicture});
}

abstract class CurrentUserHolder {
  User get user;

  bool get isEmailActivated;

  bool get isArtist;

  bool get isFan;

  bool get isArtistVerified;

  bool get isArtistPendingVerification;

  bool get isFanInTeam;

  String get uid;
}

abstract class AuthRepository {
  Future<SignupResult> signup(SignupData user);

  Future<CurrentUserHolder> getCurrentUser();

  Future login();
}

abstract class EmailAuth extends AuthRepository {
  Future<EmailValidationResult> validateEmail(String email);
}
