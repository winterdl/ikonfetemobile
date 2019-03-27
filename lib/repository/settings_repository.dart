import 'package:ikonfete/model/settings.dart';
import 'package:ikonfete/repository/repository.dart';

abstract class SettingsRepository implements Repository<Settings, String> {
  Future<Settings> findByUid(String uid);
}
