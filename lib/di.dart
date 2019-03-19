// todo: implement full fledged DI

import 'package:ikonfete/firebase_repository/activation_repository.dart';
import 'package:ikonfete/firebase_repository/artist_repository.dart';
import 'package:ikonfete/firebase_repository/auth_repository.dart';
import 'package:ikonfete/firebase_repository/fan_repository.dart';
import 'package:ikonfete/repository/activation_repository.dart';
import 'package:ikonfete/repository/artist_repository.dart';
import 'package:ikonfete/repository/auth_repository.dart';
import 'package:ikonfete/repository/fan_repository.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

//final ArtistRepository artistRepository = FirebaseArtistRepository();
//final FanRepository fanRepository = FirebaseFanRepository();
//final ActivationRepository activationRepository =
//    FirebaseActivationRepository();
//final EmailAuth emailAuthRepo =
//    FirebaseAuthRepository(artistRepository, fanRepository);

class RegistryKeys {
  static final String emailAuthRepository = "email_auth_repository";
}

class Registry {
  final Injector _injector;
  static Registry _instance = Registry._internal();

  factory Registry() => _instance;

  Registry._internal() : _injector = Injector.getInjector() {
    _injector.map<ArtistRepository>((i) => FirebaseArtistRepository());
    _injector.map<FanRepository>((i) => FirebaseFanRepository());
    _injector.map<ActivationRepository>((i) => FirebaseActivationRepository());
    _injector.map<AuthRepository>(
        (i) => FirebaseAuthRepository(
            i.get<ArtistRepository>(), i.get<FanRepository>()),
        key: RegistryKeys.emailAuthRepository);
  }

  ArtistRepository artistRepository() => _injector.get<ArtistRepository>();

  FanRepository fanRepository() => _injector.get<FanRepository>();

  ActivationRepository activationRepository() =>
      _injector.get<ActivationRepository>();

  List<AuthRepository> authRepositories() => _injector.getAll<AuthRepository>();

  EmailAuth emailAuthRepository() =>
      authRepositories().firstWhere((repo) => repo is EmailAuth, orElse: null);
}
