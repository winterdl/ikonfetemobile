import 'package:ikonfete/model/model.dart';

abstract class Repository<M extends Model<ID>, ID> {
  Future<M> create(M model);
  Future<void> update(ID id, M model);
  Future<void> delete(ID id);
  Future<M> findByID(ID id);
}