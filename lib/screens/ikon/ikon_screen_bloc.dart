import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ikonfete/exceptions.dart';
import 'package:ikonfete/model/artist.dart';
import 'package:ikonfete/model/fan.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/repository/artist_repository.dart';
import 'package:ikonfete/repository/fan_repository.dart';
import 'package:ikonfete/utils/types.dart';
import 'package:meta/meta.dart';

abstract class IkonScreenEvent {}

class LoadIkon extends IkonScreenEvent {
  final String fanUid;

  LoadIkon(this.fanUid);
}

class IkonScreenState extends Equatable {
  final bool isLoading;
  final Artist artist;
  final Pair<bool, String> loadIkonResult;

  IkonScreenState({
    @required this.isLoading,
    @required this.artist,
    @required this.loadIkonResult,
  }) : super([isLoading, artist, loadIkonResult]);

  factory IkonScreenState.initial() {
    return IkonScreenState(isLoading: true, artist: null, loadIkonResult: null);
  }

  IkonScreenState copyWith({
    bool isLoading,
    Artist artist,
    Pair<bool, String> loadIkonResult,
  }) {
    return IkonScreenState(
      isLoading: isLoading ?? this.isLoading,
      artist: artist ?? this.artist,
      loadIkonResult: loadIkonResult ?? null,
    );
  }
}

class IkonScreenBloc extends Bloc<IkonScreenEvent, IkonScreenState> {
  final ArtistRepository _artistRepository;
  final FanRepository _fanRepository;

  IkonScreenBloc()
      : _artistRepository = Registry().artistRepository(),
        _fanRepository = Registry().fanRepository();

  @override
  IkonScreenState get initialState => IkonScreenState.initial();

  @override
  Stream<IkonScreenState> mapEventToState(
      IkonScreenState currentState, IkonScreenEvent event) async* {
    if (event is LoadIkon) {
      try {
        final fan = await _fanRepository.findByUID(event.fanUid);
        if (fan == null) {
          throw AppException("Failed to load ikon");
        }

        final artist = await _artistRepository.findByID(fan.currentTeamId);
        if (artist == null) {
          throw AppException("Failed to load ikon");
        }
        yield currentState.copyWith(
            isLoading: false,
            artist: artist,
            loadIkonResult: Pair.from(true, null));
      } on AppException catch (e) {
        yield currentState.copyWith(
            isLoading: false, loadIkonResult: Pair.from(false, e.message));
      } on Exception catch (e) {
        yield currentState.copyWith(
            isLoading: false, loadIkonResult: Pair.from(false, e.toString()));
      }
    }
  }
}
