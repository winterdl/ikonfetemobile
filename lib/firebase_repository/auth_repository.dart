import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:ikonfete/exceptions.dart';
import 'package:ikonfete/model/artist.dart';
import 'package:ikonfete/model/fan.dart';
import 'package:ikonfete/model/user.dart';
import 'package:ikonfete/repository/artist_repository.dart';
import 'package:ikonfete/repository/auth_repository.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:ikonfete/repository/fan_repository.dart';
import 'package:ikonfete/repository/user_presence_repository.dart';
import 'package:ikonfete/utils/upload_helper.dart';

class FirebaseAuthRepository
    implements EmailAuthRepository, FacebookAuthRepository {
  final FirebaseAuth _firebaseAuth;
  final CloudFunctions _cloudFunctions;
  final FirebaseStorage _firebaseStorage;
  final ArtistRepository artistRepository;
  final FanRepository fanRepository;

  FirebaseAuthRepository(
      this.artistRepository, this.fanRepository)
      : _firebaseAuth = FirebaseAuth.instance,
        _cloudFunctions = CloudFunctions.instance,
        _firebaseStorage = FirebaseStorage.instance;

  /// validateEmail checks if the supplied email belongs to either an artist or a fan.
  /// The implication of this is that a user cannot signup as both an artist and a fan.
  /// In the future, consider adding an 'isArtist' parameter and calling
  /// either [fanRepository|artistRepository].findByEmail depending on the value of isArtist
  @override
  Future<EmailValidationResult> validateEmail(String email) async {
    // check if artist or fan exists
    final artist = await artistRepository.findByEmail(email);
    final errMsg = "A user with this email already exists";
    if (artist != null) {
      return EmailValidationResult(false, errMsg);
    }

    final fan = await fanRepository.findByEmail(email);
    if (fan != null) {
      return EmailValidationResult(false, errMsg);
    }

    try {
      final methods =
          await _firebaseAuth.fetchSignInMethodsForEmail(email: email);
      if (methods != null && methods.isNotEmpty) {
        return EmailValidationResult(false, errMsg);
      }
      return EmailValidationResult(true, null);
    } on PlatformException catch (e) {
      if (e.code == "ERROR_USER_NOT_FOUND") {
        return EmailValidationResult(true, null);
      } else if (e.code == "ERROR_INVALID_CREDENTIAL") {
        throw AppException("Malformed email address");
      } else {
        throw e;
      }
    }
  }

  @override
  Future<SignupResult> signup(SignupData signupData) async {
    // create firebase auth entry
    FirebaseUser firebaseUser;
    final uploadHelper = CloudStorageUploadHelper();

    try {
      firebaseUser = await _firebaseAuth.createUserWithEmailAndPassword(
          email: signupData.user.email, password: signupData.password);
    } on PlatformException catch (e) {
      switch (e.code) {
        case "ERROR_WEAK_PASSWORD":
          return SignupResult(
              success: false,
              error:
                  "Your password is too weak"); // TODO: more informative error message
        case "ERROR_INVALID_CREDENTIAL":
          return SignupResult(
              success: false, error: "The email you entered is invalid");
        case "ERROR_EMAIL_ALREADY_IN_USE":
          return SignupResult(
              success: false, error: "The email you entered is aready in use");
      }
    }

    // upload profile picture
    User user = signupData.user;
    user.uid = firebaseUser.uid;

    if (signupData.profilePicture != null) {
      try {
        final uploadResult = await uploadHelper.uploadProfilePicture(
            _firebaseStorage, firebaseUser.uid, signupData.profilePicture);
        user.profilePictureUrl = uploadResult.fileDownloadUrl;
        user.profilePictureName = uploadResult.fileName;
      } on PlatformException {
        // file upload failed, delete firebase user and return error
        await _deleteFirebaseUser(firebaseUser.uid);
        return SignupResult(
            success: false, error: "Failed to upload profile picture");
      }
    }

    try {
      // create database entries
      bool isArtist = user is Artist;
      if (isArtist) {
        user = await artistRepository.create(user as Artist);
      } else {
        user = await fanRepository.create(user as Fan);
      }

      final result = SignupResult(success: true, uid: user.uid);
      return result;
    } on PlatformException catch (e) {
      // user creation failed, delete profile picture and firebase user
      await uploadHelper.deleteProfilePicture(_firebaseStorage, user.uid);
      await _deleteFirebaseUser(firebaseUser.uid);
      return SignupResult(success: false, error: e.message);
    }
  }

  Future<bool> _deleteFirebaseUser(String uid) async {
    final result = await _cloudFunctions.call(
      functionName: "deleteFirebaseUser",
      parameters: <String, dynamic>{"uid": uid},
    );
    if (result == null) {
      return false;
    }
    return result["success"];
  }

  /// Get's the currently logged in user, or returns null
  @override
  Future<CurrentUserHolder> getCurrentUser() async {
    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    if (firebaseUser == null) {
      return null;
    }

    User user;
    if (!firebaseUser.isAnonymous) {
      user = await artistRepository.findByUID(firebaseUser.uid);
      if (user == null) {
        user = await fanRepository.findByUID(firebaseUser.uid);
      }
    }
    if (user == null) {
      return null;
    }

    return _FirebaseCurrentUserHolder(firebaseUser, user);
  }

  @override
  Future<AuthResult> emailLogin(
      bool isArtist, String email, String password) async {
    try {
      final firebaseUser = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (firebaseUser == null) {
        return AuthResult(success: false, error: "Incorrect email or password");
      }
      User user;
      if (isArtist) {
        user = await artistRepository.findByUID(firebaseUser.uid);
      } else {
        user = await fanRepository.findByUID(firebaseUser.uid);
      }

      if (user == null) {
        return AuthResult(
            success: false,
            error: "${isArtist ? "Artist" : "Fan"} account not found");
      }

      return AuthResult(
          success: true,
          currentUserHolder: _FirebaseCurrentUserHolder(firebaseUser, user));
    } on PlatformException catch (e) {
      String errMsg;
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          errMsg = "Invalid email address";
          break;
        case "ERROR_WRONG_PASSWORD":
        case "ERROR_USER_NOT_FOUND":
          errMsg = "Incorrect email or password";
          break;
        case "ERROR_USER_DISABLED":
          errMsg = "Your account has been disabled";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errMsg = "Email login not allowed";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errMsg = "Too many attempts. Please wait for a while and retry";
          break;
        case "ERROR_NETWORK_REQUEST_FAILED":
          errMsg = "A network error occurred.";
          break;
      }
      return AuthResult(success: false, error: errMsg);
    } on Exception catch (e) {
      print(e.toString());
      return AuthResult(success: false, error: "An unknown error occurred");
    }
  }

  @override
  Future<AuthResult> facebookLogin(
      bool isArtist, String facebookUid, String accessToken) async {
    try {
      // check if user is signed up
      final credential =
          FacebookAuthProvider.getCredential(accessToken: accessToken);
      final firebaseUser = await _firebaseAuth.signInWithCredential(credential);
      if (firebaseUser == null) {
        throw PlatformException(
            message: "Failed to sign in with Facebook", code: "");
      }
      final uid = firebaseUser.uid;
      User user;
      if (isArtist) {
        user = await artistRepository.findByUID(uid);
      } else {
        user = await fanRepository.findByUID(uid);
      }

      bool isNewUser = user == null;
      // if user is not signed up, create user
      if (isNewUser) {
        user = isArtist ? Artist() : Fan();
        user.uid = uid;
        user.email = firebaseUser.email;
        user.name = firebaseUser.displayName;
        user.profilePictureUrl = firebaseUser.photoUrl;
        user.facebookId = facebookUid;
        user.username = "";
        user = await (isArtist
            ? artistRepository.create(user)
            : fanRepository.create(user));
      }

      final userHolder = _FirebaseCurrentUserHolder(firebaseUser, user);
      return AuthResult(
        success: true,
        error: null,
        currentUserHolder: userHolder,
        isThirdParty: true,
      );

      // else just sign in
    } on PlatformException catch (e) {
      String msg = e.message;
      switch (e.code) {
        case "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL":
          msg = "An account with this email already exists";
          break;
        case "ERROR_USER_DISABLED":
          msg = "This account has been disabled";
          break;
      }

      return AuthResult(success: false, error: msg, isThirdParty: true);
    } on Exception catch (e) {
      print("${e.toString()}");
      return AuthResult(
          success: false, error: e.toString(), isThirdParty: true);
    }
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}

class _FirebaseCurrentUserHolder extends CurrentUserHolder {
  final FirebaseUser firebaseUser;
  final User user;

  _FirebaseCurrentUserHolder(this.firebaseUser, this.user)
      : assert(firebaseUser != null && user != null);

  @override
  bool get isArtist => user is Artist;

  @override
  bool get isArtistPendingVerification => isArtist
      ? (user as Artist).isPendingVerification
      : throw ArgumentError(
          "Cannot call isArtistPendingVerification on non-Artist User object");

  @override
  bool get isArtistVerified => isArtist
      ? (user as Artist).isVerified
      : throw ArgumentError(
          "Cannot call isArtistPendingVerification on non-Artist User object");

  @override
  bool get isEmailActivated => firebaseUser.isEmailVerified;

  @override
  bool get isFan => user is Fan;

  @override
  String get uid => firebaseUser.uid;

  @override
  bool get isFanInTeam => isArtist
      ? throw ArgumentError("Cannot call isFanInTeam on Artist User object")
      : (user as Fan).currentTeamId != null &&
          (user as Fan).currentTeamId.trim().isNotEmpty;
}
