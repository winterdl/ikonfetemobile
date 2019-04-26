import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/repository/auth_repository.dart';
import 'package:ikonfete/repository/fan_repository.dart';
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
  final AuthRepository authRepository;
  final FanRepository fanRepository;

  FanHomeBloc()
      : fanRepository = Registry().fanRepository(),
        authRepository = Registry().authRepository();

  @override
  FanHomeState get initialState => FanHomeState.initial();

  @override
  Stream<FanHomeState> mapEventToState(
      FanHomeState currentState, FanHomeEvent event) async* {
    if (event is RegisterOnline) {
      fanRepository.regsterOnline(event.uid);
    }
  }
}
