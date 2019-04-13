import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:ikonfete/model/artist.dart';
import 'package:ikonfete/model/user.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/repository/artist_repository.dart';
import 'package:ikonfete/repository/fan_repository.dart';
import 'package:ikonfete/utils/strings.dart';
import 'package:ikonfete/utils/types.dart';
import 'package:ikonfete/utils/upload_helper.dart';
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

class UpdateFacebookId extends ProfileScreenEvent {
  final String facebookId;

  UpdateFacebookId(this.facebookId);
}

class UpdateTwitterId extends ProfileScreenEvent {
  final String twitterId;

  UpdateTwitterId(this.twitterId);
}

class EditBio extends ProfileScreenEvent {}

class CancelEditBio extends ProfileScreenEvent {}

class BioEdited extends ProfileScreenEvent {
  final String newVal;

  BioEdited(this.newVal);
}

class ProfileInfoEdited extends ProfileScreenEvent {
  final File profilePicture;
  final String displayName;
  final String countryIsoCode;
  final String country;

  ProfileInfoEdited({
    @required this.profilePicture,
    @required this.displayName,
    @required this.countryIsoCode,
    @required this.country,
  });
}

class SaveProfile extends ProfileScreenEvent {}

class _SaveProfile extends ProfileScreenEvent {}

class ProfileScreenState extends Equatable {
  final bool isLoading;
  final User user;
  final Pair<bool, String> loadUserResult;
  final String newFacebookId;
  final String newTwitterId;
//  final Pair<bool, String> enableFacebookResult;
//  final Pair<bool, String> enableTwitterResult;
  final bool editBio;
  final String newBio;
  final File newProfilePicture;
  final String newDisplayName;
  final String newCountryCode;
  final String newCountryName;
  final Pair<bool, String> updateProfileResult;

  ExclusivePair<String, File> get profilePicture {
    if (newProfilePicture != null)
      return ExclusivePair.withSecond(newProfilePicture);

    if (user == null || StringUtils.isNullOrEmpty(user.profilePictureUrl))
      return null;

    return ExclusivePair.withFirst(user.profilePictureUrl);
  }

  String get displayName {
    if (!StringUtils.isNullOrEmpty(newDisplayName)) return newDisplayName;
    return user?.name ?? "";
  }

  String get username {
    // todo: allow updates to usernames
    return user?.username ?? "";
  }

  String get country {
    if (!StringUtils.isNullOrEmpty(newCountryName)) return newCountryName;
    return user?.country ?? "";
  }

  String get email {
    return user?.email ?? "";
  }

  String get bio {
    if (!StringUtils.isNullOrEmpty(newBio)) return newBio;
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

  bool get changesMade {
    if (user == null) return false;

    if (user is Artist) {
      if (!StringUtils.isNullOrEmpty(newBio) &&
          newBio != (user as Artist).bio) {
        return true;
      }
    }

    return (!StringUtils.isNullOrEmpty(newFacebookId) &&
            newFacebookId != user.facebookId) ||
        (!StringUtils.isNullOrEmpty(newTwitterId) &&
            newTwitterId != user.twitterId) ||
        newProfilePicture != null ||
        (!StringUtils.isNullOrEmpty(newDisplayName) &&
            newDisplayName != user.name) ||
        (!StringUtils.isNullOrEmpty(newCountryCode) &&
            newCountryCode.toLowerCase() != user.countryIsoCode.toLowerCase());
  }

  ProfileScreenState({
    @required this.isLoading,
    @required this.user,
    @required this.loadUserResult,
    @required this.newFacebookId,
    @required this.newTwitterId,
//    @required this.enableFacebookResult,
//    @required this.enableTwitterResult,
    @required this.editBio,
    @required this.newBio,
    @required this.newProfilePicture,
    @required this.newDisplayName,
    @required this.newCountryCode,
    @required this.newCountryName,
    @required this.updateProfileResult,
  }) : super([
          isLoading,
          user,
          loadUserResult,
          newFacebookId,
          newTwitterId,
//          enableFacebookResult,
//          enableTwitterResult,
          editBio,
          newBio,
          newProfilePicture,
          newDisplayName,
          newCountryCode,
          newCountryName,
          updateProfileResult,
        ]);

  factory ProfileScreenState.initial() {
    return ProfileScreenState(
      isLoading: false,
      user: null,
      loadUserResult: null,
      newFacebookId: null,
      newTwitterId: null,
//      enableFacebookResult: null,
//      enableTwitterResult: null,
      editBio: false,
      newBio: null,
      newProfilePicture: null,
      newDisplayName: null,
      newCountryCode: null,
      newCountryName: null,
      updateProfileResult: null,
    );
  }

  ProfileScreenState copyWith({
    bool isLoading,
    User user,
    Pair<bool, String> loadUserResult,
    String newFacebookId,
    String newTwitterId,
//    Pair<bool, String> enableFacebookResult,
//    Pair<bool, String> enableTwitterResult,
    bool editBio,
    String newBio,
    File newProfilePicture,
    String newDisplayName,
    String newCountryCode,
    String newCountryName,
    Pair<bool, String> updateProfileResult,
  }) {
    return ProfileScreenState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      loadUserResult: loadUserResult ?? null,
      newFacebookId: newFacebookId ?? this.newFacebookId,
      newTwitterId: newTwitterId ?? this.newTwitterId,
//      enableFacebookResult: enableFacebookResult ?? null,
//      enableTwitterResult: enableTwitterResult ?? null,
      editBio: editBio ?? this.editBio,
      newBio: newBio ?? this.newBio,
      newProfilePicture: newProfilePicture ?? this.newProfilePicture,
      newDisplayName: newDisplayName ?? this.newDisplayName,
      newCountryCode: newCountryCode ?? this.newCountryCode,
      newCountryName: newCountryName ?? this.newCountryName,
      updateProfileResult: updateProfileResult ?? null,
    );
  }
}

class ProfileScreenBloc extends Bloc<ProfileScreenEvent, ProfileScreenState> {
  final String uid;
  final bool isArtist;
  final ArtistRepository _artistRepository;
  final FanRepository _fanRepository;

  ProfileScreenBloc({
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
    if (event is SaveProfile) {
      dispatch(_SaveProfile());
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

    if (event is UpdateFacebookId) {
      yield state.copyWith(newFacebookId: event.facebookId);
    }

    if (event is UpdateTwitterId) {
      yield state.copyWith(newTwitterId: event.twitterId);
    }

    if (event is EditBio) {
      yield state.copyWith(editBio: true);
    }

    if (event is CancelEditBio) {
      yield state.copyWith(editBio: false);
    }

    if (event is BioEdited) {
      yield state.copyWith(newBio: event.newVal, editBio: false);
    }

    if (event is ProfileInfoEdited) {
      yield state.copyWith(
        newProfilePicture: event.profilePicture,
        newDisplayName: event.displayName,
        newCountryCode: event.countryIsoCode,
        newCountryName: event.country,
      );
    }

    if (event is SaveProfile) {
      yield state.copyWith(isLoading: true);
    }

    if (event is _SaveProfile) {
      final result = await _saveProfile(state);
      yield state.copyWith(isLoading: false, updateProfileResult: result);
    }
  }

  Future<Pair<bool, String>> _saveProfile(ProfileScreenState state) async {
    final user = state.user;

    if (state.newProfilePicture != null) {
      try {
        final uploadHelper = CloudStorageUploadHelper();
        if (!StringUtils.isNullOrEmpty(state.user.profilePictureUrl)) {
          bool deleted = await uploadHelper.deleteProfilePicture(
              FirebaseStorage.instance, uid);
          if (!deleted) {
            return Pair.from(false, "Failed to delete old profile picture");
          }
        }

        final uploadResult = await uploadHelper.uploadProfilePicture(
            FirebaseStorage.instance, uid, state.newProfilePicture);
        user.profilePictureUrl = uploadResult.fileDownloadUrl;
        user.profilePictureName = uploadResult.fileName;
      } on PlatformException catch (e) {
        return Pair.from(false, e.message);
      } on Exception catch (e) {
        return Pair.from(false, e.toString());
      }
    }

    if (isArtist && !StringUtils.isNullOrEmpty(state.newBio)) {
      (user as Artist).bio = state.newBio;
    }

    if (!StringUtils.isNullOrEmpty(state.newFacebookId)) {
      user.facebookId = state.newFacebookId;
    }

    if (!StringUtils.isNullOrEmpty(state.newTwitterId)) {
      user.twitterId = state.newTwitterId;
    }

    if (!StringUtils.isNullOrEmpty(state.newDisplayName)) {
      user.name = state.newDisplayName;
    }

    if (!StringUtils.isNullOrEmpty(state.newCountryCode)) {
      user.countryIsoCode = state.newCountryCode;
      user.country = state.newCountryName;
    }

    // update the artist or fan
    try {
      if (isArtist) {
        await _artistRepository.update(user.id, user);
      } else {
        await _fanRepository.update(user.id, user);
      }
      return Pair.from(true, null);
    } on PlatformException catch (e) {
      return Pair.from(false, e.message);
    } on Exception catch (e) {
      return Pair.from(false, e.toString());
    }
  }
}
