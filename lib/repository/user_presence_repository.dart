import 'package:ikonfete/model/presence.dart';
import 'package:ikonfete/repository/repository.dart';

abstract class UserPresenceRepository
    implements Repository<UserPresence, String> {
  Future<void> registerPresence(UserPresence presence);

  Future<UserPresence> findByUid(String uid);
}
