import 'package:ikonfete/model/activation.dart';
import 'package:ikonfete/repository/repository.dart';

abstract class ActivationRepository implements Repository<Activation, String> {
  Future<Activation> findByUID(String uid);

  Future<Activation> findByCode(String code);
}
