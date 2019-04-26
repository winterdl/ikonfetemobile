import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ikonfete/model/presence.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/repository/user_presence_repository.dart';
import 'package:meta/meta.dart';

abstract class FanHomeEvent {}

class RegisterOnline extends FanHomeEvent {
  final String uid;

  RegisterOnline(this.uid);
}

class FanHomeState extends Equatable {
  final bool isLoading;

  FanHomeState({
    @required this.isLoading,
  }) : super([isLoading]);

  factory FanHomeState.initial() {
    return FanHomeState(
      isLoading: false,
    );
  }
}

class FanHomeBloc extends Bloc<FanHomeEvent, FanHomeState> {
  final UserPresenceRepository userPresenceRepository;

  FanHomeBloc() : userPresenceRepository = Registry().userPresenceRepository();

  @override
  FanHomeState get initialState => FanHomeState.initial();

  @override
  Stream<FanHomeState> mapEventToState(
      FanHomeState currentState, FanHomeEvent event) async* {
    if (event is RegisterOnline) {
      UserPresence presence;
      presence =
          (await userPresenceRepository.findByUid(event.uid)) ?? UserPresence()
            ..uid = event.uid;
      presence.online = true;
      presence.lastSeen = DateTime.now();
      userPresenceRepository.registerPresence(presence);
    }
  }
}
