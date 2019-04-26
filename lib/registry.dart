import 'package:ikonfete/firebase_repository/activation_repository.dart';
import 'package:ikonfete/firebase_repository/artist_repository.dart';
import 'package:ikonfete/firebase_repository/auth_repository.dart';
import 'package:ikonfete/firebase_repository/fan_repository.dart';
import 'package:ikonfete/firebase_repository/settings_repository.dart';
import 'package:ikonfete/firebase_repository/pending_verification_repository.dart';
import 'package:ikonfete/repository/activation_repository.dart';
import 'package:ikonfete/repository/artist_repository.dart';
import 'package:ikonfete/repository/auth_repository.dart';
import 'package:ikonfete/repository/fan_repository.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:ikonfete/repository/pending_verification_repository.dart';
import 'package:ikonfete/repository/settings_repository.dart';

class RegistryKeys {
  static final String emailAuthRepository = "email_auth_repository";
  static final String twitterConsumerKey = "twitter_consumer_key";
  static final String twitterConsumerSecret = "twitter_consumer_secret";
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
    _injector.map<PendingVerificationRepository>(
        (i) => FirebasePendingVerificationRepository());
    _injector.map<SettingsRepository>((i) => FirebaseSettingsRepository());
  }

  ArtistRepository artistRepository() => _injector.get<ArtistRepository>();

  FanRepository fanRepository() => _injector.get<FanRepository>();

  ActivationRepository activationRepository() =>
      _injector.get<ActivationRepository>();

  List<AuthRepository> authRepositories() => _injector.getAll<AuthRepository>();

  EmailAuthRepository authRepository() => authRepositories()
      .firstWhere((repo) => repo is EmailAuthRepository, orElse: null);

  PendingVerificationRepository pendingVerificationRepository() =>
      _injector.get<PendingVerificationRepository>();

  SettingsRepository settingsRepository() =>
      _injector.get<SettingsRepository>();

}
