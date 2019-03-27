import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ikonfete/model/artist.dart';
import 'package:ikonfete/model/user.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/repository/artist_repository.dart';
import 'package:ikonfete/repository/fan_repository.dart';
import 'package:ikonfete/twitter/twitter_config.dart';
import 'package:ikonfete/utils/facebook_auth.dart';
import 'package:ikonfete/utils/strings.dart';
import 'package:ikonfete/utils/twitter_auth.dart';
import 'package:ikonfete/utils/types.dart';
import 'package:meta/meta.dart';

class EditProfileData {
  bool isArtist;
  String uid;
  String displayName;
  String facebookId;
  String twitterId;
  String bio;
  String countryIsoCode;
  File profilePicture;
  String profilePictureUrl;
  String oldProfilePictureUrl;
  bool removeFacebook;
  bool removeTwitter;
}

abstract class ProfileScreenEvent {}

class LoadProfile extends ProfileScreenEvent {}

class EnableFacebook extends ProfileScreenEvent {
  final bool enabled;

  EnableFacebook(this.enabled);
}

class EnableTwitter extends ProfileScreenEvent {
  final bool enabled;

  EnableTwitter(this.enabled);
}

class ProfileInfoChange extends ProfileScreenEvent {
  final File profilePicture;
  final String displayName;
  final String countryIsoCode;
  final String country;

  ProfileInfoChange({
    @required this.profilePicture,
    @required this.displayName,
    @required this.countryIsoCode,
    @required this.country,
  });
}

class BioUpdated extends ProfileScreenEvent {
  final String bio;

  BioUpdated(this.bio);
}

class EditProfile extends ProfileScreenEvent {
  final EditProfileData data;

  EditProfile(this.data);
}

class _EditProfile extends ProfileScreenEvent {
  final EditProfileData data;

  _EditProfile(this.data);
}

class ProfileScreenState extends Equatable {
  final bool isLoading;
  final User user;
  final Pair<bool, String> loadUserResult;
  final String newFacebookId;
  final String newTwitterId;
  final Pair<bool, String> enableFacebookResult;
  final Pair<bool, String> enableTwitterResult;

  ExclusivePair<String, File> get profilePicture {
    // todo: check for updates to profile
    if (user == null || StringUtils.isNullOrEmpty(user.profilePictureUrl)) {
      return null;
    }

    return ExclusivePair.withFirst(user.profilePictureUrl);
  }

  String get displayName {
    // todo check for updates
    return user?.name ?? "";
  }

  String get username {
    // todo
    return user?.username ?? "";
  }

  String get country {
    // todo
    return user?.country ?? "";
  }

  String get email {
    // todo
    return user?.email ?? "";
  }

  String get bio {
    // todo
    if (user == null) return "";
    return user is Artist ? (user as Artist).bio : "";
  }

  bool get facebookEnabled {
    if (!StringUtils.isNullOrEmpty(newFacebookId)) return true;
    if (user == null) return false;
    return !StringUtils.isNullOrEmpty(user.facebookId);
  }

  bool get twitterEnabled {
    if (!StringUtils.isNullOrEmpty(newTwitterId)) return true;
    if (user == null) return false;
    return !StringUtils.isNullOrEmpty(user.twitterId);
  }

  bool get changesMade => false;

//  final bool hasError;
//  final String errorMessage;
//  final bool editProfileResult;
//
//  final String displayName;
//  final String profilePictureUrl;
//  final String username;
//  final String country;
//  final String countryIsoCode;
//  final String email;
//  final String bio;
//  final bool facebookEnabled;
//  final bool twitterEnabled;
//  final String facebookId;
//  final String twitterId;
//
//  final String newDisplayName;
//  final File newProfilePicture;
//  final String newCountry;
//  final String newCountryIsoCode;
//  final String newBio;
//  final String newFacebookId;
//  final String newTwitterId;

  //    @required this.errorMessage,
//    @required this.editProfileResult,
//    @required this.displayName,
//    @required this.profilePictureUrl,
//    @required this.username,
//    @required this.country,
//    @required this.countryIsoCode,
//    @required this.email,
//    @required this.bio,
//    @required this.facebookEnabled,
//    @required this.twitterEnabled,
//    @required this.facebookId,
//    @required this.twitterId,
//    @required this.newDisplayName,
//    @required this.newProfilePicture,
//    @required this.newCountry,
//    @required this.newCountryIsoCode,
//    @required this.newBio,
//    @required this.newFacebookId,
//    @required this.newTwitterId,

  ProfileScreenState({
    @required this.isLoading,
    @required this.user,
    @required this.loadUserResult,
    @required this.newFacebookId,
    @required this.newTwitterId,
    @required this.enableFacebookResult,
    @required this.enableTwitterResult,
  }) : super([
          isLoading,
          user,
          loadUserResult,
          newFacebookId,
          newTwitterId,
          enableFacebookResult,
          enableTwitterResult
        ]);

  //      hasError: false,
//      errorMessage: "",
//      editProfileResult: false,
//      displayName: "",
//      profilePictureUrl: "",
//      username: "",
//      country: "",
//      countryIsoCode: "",
//      email: "",
//      bio: "",
//      facebookEnabled: false,
//      twitterEnabled: false,
//      facebookId: "",
//      twitterId: "",
//      newDisplayName: "",
//      newProfilePicture: null,
//      newCountry: "",
//      newCountryIsoCode: "",
//      newBio: "",
//      newFacebookId: "",
//      newTwitterId: "",

  factory ProfileScreenState.initial() {
    return ProfileScreenState(
      isLoading: false,
      user: null,
      loadUserResult: null,
      newFacebookId: null,
      newTwitterId: null,
      enableFacebookResult: null,
      enableTwitterResult: null,
    );
  }

  ProfileScreenState copyWith({
    bool isLoading,
    User user,
    Pair<bool, String> loadUserResult,
    String newFacebookId,
    String newTwitterId,
    Pair<bool, String> enableFacebookResult,
    Pair<bool, String> enableTwitterResult,
//    bool editProfileResult,
//    String profilePictureUrl,
//    String username,
//    String country,
//    String countryIsoCode,
//    String email,
//    String bio,
//    bool facebookEnabled,
//    bool twitterEnabled,
//    String facebookId,
//    String twitterId,
//    bool hasError,
//    String errorMessage,
//    String newDisplayName,
//    File newProfilePicture,
//    String newCountry,
//    String newCountryIsoCode,
//    String newBio,
//    String newFacebookId,
//    String newTwitterId,
  }) {
    return ProfileScreenState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      loadUserResult: loadUserResult ?? null,
      newFacebookId: newFacebookId ?? this.newFacebookId,
      newTwitterId: newTwitterId ?? this.newTwitterId,
      enableFacebookResult: enableFacebookResult ?? null,
      enableTwitterResult: enableTwitterResult ?? null,
//      displayName: displayName ?? this.displayName,
//      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
//      username: username ?? this.username,
//      country: country ?? this.country,
//      countryIsoCode: countryIsoCode ?? this.countryIsoCode,
//      email: email ?? this.email,
//      bio: bio ?? this.bio,
//      facebookEnabled: facebookEnabled ?? this.facebookEnabled,
//      twitterEnabled: twitterEnabled ?? this.twitterEnabled,
//      facebookId: facebookId ?? this.facebookId,
//      twitterId: twitterId ?? this.twitterId,
//      hasError: hasError ?? this.hasError,
//      errorMessage: errorMessage ?? this.errorMessage,
//      newDisplayName: newDisplayName ?? this.newDisplayName,
//      newProfilePicture: newProfilePicture ?? this.newProfilePicture,
//      newCountryIsoCode: newCountryIsoCode ?? this.newCountryIsoCode,
//      newCountry: newCountry ?? this.newCountry,
//      newBio: newBio ?? this.newBio,
//      newFacebookId: newFacebookId ?? this.newFacebookId,
//      newTwitterId: newTwitterId ?? this.newTwitterId,
    );
  }
}

class ProfileScreenBloc extends Bloc<ProfileScreenEvent, ProfileScreenState> {
  final TwitterConfig twitterConfig;
  final String uid;
  final bool isArtist;
  final ArtistRepository _artistRepository;
  final FanRepository _fanRepository;

  ProfileScreenBloc({
    @required this.twitterConfig,
    @required this.uid,
    @required this.isArtist,
  })  : _artistRepository = Registry().artistRepository(),
        _fanRepository = Registry().fanRepository();

  @override
  ProfileScreenState get initialState => ProfileScreenState.initial();

  @override
  void onTransition(
      Transition<ProfileScreenEvent, ProfileScreenState> transition) {
    super.onTransition(transition);
    final event = transition.event;
    if (event is EditProfile) {
      dispatch(_EditProfile(event.data));
    }
  }

  @override
  Stream<ProfileScreenState> mapEventToState(
      ProfileScreenState state, ProfileScreenEvent event) async* {
    if (event is LoadProfile) {
      final user = await (isArtist
          ? _artistRepository.findByUID(uid)
          : _fanRepository.findByUID(uid));
      yield state.copyWith(
        isLoading: false,
        user: user,
        loadUserResult: Pair.from(
            user != null, user != null ? null : "Failed to load user"),
      );
    }

    if (event is EnableFacebook) {
      if (!event.enabled) {
        yield state.copyWith(newFacebookId: "");
      } else {
        final authResult = await FacebookAuth().facebookAuth();
        if (authResult.success) {
          yield state.copyWith(
            isLoading: false,
            newFacebookId: authResult.facebookUID,
            enableFacebookResult: Pair.from(true, null),
          );
        } else {
          yield state.copyWith(
              isLoading: false,
              enableFacebookResult: Pair.from(false, authResult.errorMessage));
        }
      }
    }

    if (event is EnableTwitter) {
      if (!event.enabled) {
        yield state.copyWith(newTwitterId: "");
      } else {
        final twitterAuth = TwitterAuth(
            consumerKey: twitterConfig.consumerKey,
            consumerSecret: twitterConfig.consumerSecret);
        final authResult = await twitterAuth.twitterAuth();
        if (authResult.success) {
          yield state.copyWith(
            isLoading: false,
            newTwitterId: authResult.twitterUID,
            enableTwitterResult: Pair.from(true, null),
          );
        } else {
          yield state.copyWith(
              isLoading: false,
              enableTwitterResult: Pair.from(false, authResult.errorMessage));
        }
      }
    }
//    if (event is InitProfile) {
//
//      final artist = isArtist ? event.appState.artistOrFan.first : null;
//      final fan = isArtist ? null : event.appState.artistOrFan.second;
//      final displayName = isArtist ? artist.name : fan.name;
//      final profilePictureUrl =
//          isArtist ? artist.profilePictureUrl : fan.profilePictureUrl;
//      final username = isArtist ? artist.username : fan.username;
//      final country = isArtist ? artist.country : fan.country;
//      final countryIsoCode =
//          isArtist ? artist.countryIsoCode : fan.countryIsoCode;
//      final email = isArtist ? artist.email : fan.email;
//      final bio = isArtist ? artist.bio : "";
//      final facebookEnabled = isArtist
//          ? !StringUtils.isNullOrEmpty(artist.facebookId)
//          : !StringUtils.isNullOrEmpty(fan.facebookId);
//      final twitterEnabled = isArtist
//          ? !StringUtils.isNullOrEmpty(artist.twitterId)
//          : !StringUtils.isNullOrEmpty(fan.twitterId);
//      final facebookId = isArtist ? artist.facebookId : fan.facebookId;
//      final twitterId = isArtist ? artist.twitterId : fan.twitterId;
//
//      yield state.copyWith(
//        isLoading: false,
//        hasError: false,
//        errorMessage: "",
//        displayName: displayName,
//        profilePictureUrl: profilePictureUrl,
//        username: username,
//        country: country,
//        countryIsoCode: countryIsoCode,
//        email: email,
//        bio: bio,
//        facebookEnabled: facebookEnabled,
//        twitterEnabled: twitterEnabled,
//        facebookId: facebookId,
//        twitterId: twitterId,
//        newDisplayName: "",
//        newCountry: "",
//        newCountryIsoCode: "",
//        newBio: "",
//        newFacebookId: facebookId,
//        newTwitterId: twitterId,
//      );
//    }
//
//    if (event is EditProfile) {
//      yield state.copyWith(isLoading: true, hasError: false, errorMessage: "");
//    }
//
//    if (event is _EditProfile) {
//      try {
//        final success = await _editProfile(event.data);
//        yield state.copyWith(
//            hasError: false, errorMessage: "", editProfileResult: success);
//      } on Exception catch (e) {
//        yield state.copyWith(
//            isLoading: false, hasError: true, errorMessage: e.toString());
//      }
//    }
//
//    if (event is ProfileInfoChange) {
//      yield state.copyWith(
//        hasError: false,
//        countryIsoCode: event.countryIsoCode,
//        country: event.country,
//        newProfilePicture: event.profilePicture,
//        newDisplayName: event.displayName,
//      );
//    }
//
//    if (event is BioUpdated) {
//      yield state.copyWith(
//          hasError: false, errorMessage: "", newBio: event.bio);
//    }
//
//    try {
//      if (event is FacebookEnabled) {
//        if (event.enabled) {
//          // enable facebook
//          final result = await _enableFacebook();
//          if (result.success) {
//            yield state.copyWith(
//                hasError: false,
//                errorMessage: "",
//                facebookEnabled: event.enabled,
//                newFacebookId: result.facebookUID);
//          } else {
//            yield state.copyWith(
//              hasError: false,
//              errorMessage: "",
//              facebookEnabled: false,
//              newFacebookId: "",
//            );
//          }
//        } else {
//          yield state.copyWith(
//            hasError: false,
//            errorMessage: "",
//            facebookEnabled: false,
//            newFacebookId: "",
//          );
//        }
//      }
//
//      if (event is TwitterEnabled) {
//        if (event.enabled) {
//          final result = await _enableTwitter();
//          if (result.success) {
//            yield state.copyWith(
//                hasError: false,
//                errorMessage: "",
//                twitterEnabled: event.enabled,
//                newTwitterId: result.twitterUID);
//          } else {
//            yield state.copyWith(
//                hasError: false,
//                errorMessage: "",
//                twitterEnabled: false,
//                newTwitterId: "");
//          }
//        } else {
//          yield state.copyWith(
//              hasError: false,
//              errorMessage: "",
//              twitterEnabled: false,
//              newTwitterId: "");
//        }
//      }
//    } on Exception catch (e) {
//      yield state.copyWith(hasError: true, errorMessage: e.toString());
//    }
  }

  Future<FacebookAuthResult> _enableFacebook() async {
    final facebookAuth = FacebookAuth();
    final result = await facebookAuth.facebookAuth();
    return result;
  }

  Future<TwitterAuthResult> _enableTwitter() async {
//    final twitterAuth = TwitterAuth(appConfig: appConfig);
//    final result = await twitterAuth.twitterAuth();
//    return result;
    return null;
  }

  Future<bool> _editProfile(EditProfileData data) async {
//    try {
//      if (data.profilePicture != null) {
//        // delete the old profilePicture
//        final uploadHelper = CloudStorageUploadHelper();
//        try {
//          if (!StringUtils.isNullOrEmpty(data.oldProfilePictureUrl)) {
//            uploadHelper.deleteProfilePicture(
//                FirebaseStorage.instance, data.uid);
//          }
//        } on PlatformException catch (e) {} // if deletion fails, do nothing
//
//        // upload a new profile picture, if one was specified
//        final uploadResult = await uploadHelper.uploadProfilePicture(
//            FirebaseStorage.instance, data.uid, data.profilePicture);
//        data.profilePictureUrl = uploadResult.fileDownloadUrl;
//      }
//
//      // make call to update profile api
//      final profileApi = ProfileApi(appConfig.serverBaseUrl);
//      bool updated = await profileApi.updateProfile(data);
//      return updated;
//    } on ApiException catch (e) {
//      throw e;
//    } on PlatformException catch (e) {
//      throw ApiException(e.message);
//    } on Exception catch (e) {
//      throw ApiException(e.toString());
//    }
  }
}
