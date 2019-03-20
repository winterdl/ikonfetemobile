import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:ikonfete/model/artist.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/repository/artist_repository.dart';
import 'package:ikonfete/utils/types.dart';
import 'package:meta/meta.dart';

abstract class PendingVerificationScreenEvents {}

class LoadUser extends PendingVerificationScreenEvents {
  final String uid;

  LoadUser(this.uid);
}

class PendingVerificationScreenState {
  final bool isLoading;
  final Artist artist;
  final Pair<bool, String> loadArtistResult;

  PendingVerificationScreenState({
    @required this.isLoading,
    @required this.artist,
    @required this.loadArtistResult,
  });

  factory PendingVerificationScreenState.initial() {
    return PendingVerificationScreenState(
      isLoading: true,
      artist: null,
      loadArtistResult: null,
    );
  }

  bool get hasError => loadArtistResult != null && !loadArtistResult.first;

  bool get hasData => artist != null;

  PendingVerificationScreenState copyWith({
    bool isLoading,
    Artist artist,
    Pair<bool, String> loadArtistResult,
  }) {
    return PendingVerificationScreenState(
      isLoading: isLoading ?? this.isLoading,
      artist: artist ?? this.artist,
      loadArtistResult: loadArtistResult,
    );
  }

  @override
  bool operator ==(other) =>
      identical(this, other) &&
      other is PendingVerificationScreenState &&
      runtimeType == other.runtimeType &&
      isLoading == other.isLoading &&
      artist == other.artist &&
      loadArtistResult == other.loadArtistResult;

  @override
  int get hashCode =>
      isLoading.hashCode ^ artist.hashCode ^ loadArtistResult.hashCode;
}

class PendingVerificationBloc extends Bloc<PendingVerificationScreenEvents,
    PendingVerificationScreenState> {
  final ArtistRepository artistRepository;

  PendingVerificationBloc() : artistRepository = Registry().artistRepository();

  @override
  PendingVerificationScreenState get initialState =>
      PendingVerificationScreenState.initial();

  @override
  Stream<PendingVerificationScreenState> mapEventToState(
      PendingVerificationScreenState state,
      PendingVerificationScreenEvents event) async* {
    if (event is LoadUser) {
      try {
        final artist = await artistRepository.findByUID(event.uid);
        if (artist == null) {
          yield state.copyWith(
              isLoading: false,
              artist: null,
              loadArtistResult: Pair.from(false, "Artist not found"));
        }

        yield state.copyWith(
            isLoading: false,
            artist: artist,
            loadArtistResult: Pair.from(true, null));
      } on PlatformException catch (e) {
        yield state.copyWith(
            isLoading: false,
            artist: null,
            loadArtistResult: Pair.from(false, e.message));
      } on Exception catch (e) {
        yield state.copyWith(
            isLoading: false,
            artist: null,
            loadArtistResult: Pair.from(false, e.toString()));
      }
    }
  }
}
