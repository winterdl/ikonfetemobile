import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ikonfete/model/sex.dart';
import 'package:ikonfete/model/user.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/repository/auth_repository.dart';
import 'package:ikonfete/screens/signup/bloc_models.dart';
import 'package:meta/meta.dart';

abstract class SignupMainScreenEvent {}

class NameEntered extends SignupMainScreenEvent {
  final String name;

  NameEntered(this.name);
}

class EmailEntered extends SignupMainScreenEvent {
  final String email;

  EmailEntered(this.email);
}

class PasswordEntered extends SignupMainScreenEvent {
  final String password;

  PasswordEntered(this.password);
}

class SexSelected extends SignupMainScreenEvent {
  final Sex sex;

  SexSelected(this.sex);
}

class ValidateForm extends SignupMainScreenEvent {
  final bool isArtist;

  ValidateForm({this.isArtist});
}

class _ValidateForm extends SignupMainScreenEvent {
  final bool isArtist;

  _ValidateForm({this.isArtist});
}

class SignupMainScreenState extends Equatable {
  final String name;
  final String email;
  final String password;
  final Sex sex;
  final bool isLoading;
  final SignupValidationResult result;

  SignupMainScreenState({
    @required this.name,
    @required this.email,
    @required this.password,
    @required this.sex,
    @required this.isLoading,
    @required this.result,
  }) : super([name, email, password, sex, isLoading, result]);

  factory SignupMainScreenState.initial() {
    return SignupMainScreenState(
      name: null,
      email: null,
      password: null,
      sex: null,
      isLoading: false,
      result: null,
    );
  }

  SignupMainScreenState copyWith({
    String name,
    String email,
    String password,
    Sex sex,
    bool isLoading,
    SignupValidationResult result,
  }) {
    return SignupMainScreenState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      sex: sex ?? this.sex,
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
    );
  }
}

class SignupMainBloc
    extends Bloc<SignupMainScreenEvent, SignupMainScreenState> {
  final EmailAuthRepository emailAuthRepository;

  SignupMainBloc() : emailAuthRepository = Registry().authRepository();

  @override
  SignupMainScreenState get initialState => SignupMainScreenState.initial();

  @override
  void onTransition(
      Transition<SignupMainScreenEvent, SignupMainScreenState> transition) {
    final event = transition.event;
    if (event is ValidateForm) {
      dispatch(_ValidateForm(isArtist: event.isArtist));
    }
  }

  @override
  Stream<SignupMainScreenState> mapEventToState(
      SignupMainScreenState state, SignupMainScreenEvent event) async* {
    if (event is NameEntered) {
      yield state.copyWith(name: event.name);
    }
    if (event is EmailEntered) {
      yield state.copyWith(email: event.email);
    }
    if (event is PasswordEntered) {
      yield state.copyWith(password: event.password);
    }
    if (event is SexSelected) {
      yield state.copyWith(sex: event.sex);
    }

    if (event is ValidateForm) {
      yield state.copyWith(isLoading: true);
    }

    if (event is _ValidateForm) {
      final result = await validateForm(state);
      yield state.copyWith(result: result, isLoading: false);
    }
  }

  Future<SignupValidationResult> validateForm(
      SignupMainScreenState state) async {
    if (state.sex == null) {
      return SignupValidationResult(
          success: false,
          error: "Select your sex",
          email: null,
          password: null,
          sex: null,
          name: null);
    }

    final validationResult =
        await emailAuthRepository.validateEmail(state.email);

    return SignupValidationResult(
        name: state.name,
        email: state.email,
        password: state.password,
        sex: state.sex,
        success: validationResult.isValid,
        error: validationResult.error);
  }
}
