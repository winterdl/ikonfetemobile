import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/repository/auth_repository.dart';
import 'package:meta/meta.dart';

abstract class ZoomScaffoldScreenEvent {}

class LoadCurrentUser extends ZoomScaffoldScreenEvent {}

class ZoomScaffoldBlocState extends Equatable {
  final bool isLoading;
  final CurrentUserHolder currentUser;

  ZoomScaffoldBlocState({
    this.isLoading,
    this.currentUser,
  }) : super([isLoading, currentUser]);

  factory ZoomScaffoldBlocState.initial() =>
      ZoomScaffoldBlocState(isLoading: true, currentUser: null);

  ZoomScaffoldBlocState copyWith({
    bool isLoading,
    CurrentUserHolder currentUser,
  }) {
    return ZoomScaffoldBlocState(
      isLoading: isLoading ?? this.isLoading,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}

class ZoomScaffoldBloc
    extends Bloc<ZoomScaffoldScreenEvent, ZoomScaffoldBlocState> {
  final bool isArtist;
  final String uid;
  final EmailAuth _emailAuth;

  ZoomScaffoldBloc({@required this.isArtist, @required this.uid})
      : _emailAuth = Registry().emailAuthRepository();

  @override
  ZoomScaffoldBlocState get initialState => ZoomScaffoldBlocState.initial();

  @override
  Stream<ZoomScaffoldBlocState> mapEventToState(
      ZoomScaffoldBlocState currentState,
      ZoomScaffoldScreenEvent event) async* {
    if (event is LoadCurrentUser) {
      final user = await _emailAuth.getCurrentUser();
      yield currentState.copyWith(isLoading: false, currentUser: user);
    }
  }
}
