import 'package:ikonfete/model/fan.dart';
import 'package:ikonfete/repository/repository.dart';

abstract class FanRepository implements Repository<Fan, String> {
  Future<Fan> findByUID(String uid);

  Future<Fan> findByUsername(String username);

  Future<Fan> findByEmail(String email);
}
