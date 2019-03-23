import 'package:ikonfete/firebase_repository/firebase_repository.dart';
import 'package:ikonfete/model/activation.dart';
import 'package:ikonfete/repository/activation_repository.dart';

class FirebaseActivationRepository extends FirestoreRepository<Activation>
    implements ActivationRepository {
  final ModelBuilder<Activation> activationModelBuilder =
      (Map<String, dynamic> data) => Activation()..fromJson(data);

  FirebaseActivationRepository([String collection = "activations"])
      : super(collection);

  @override
  Future<Activation> create(Activation model) {
    return firestoreCreate(model);
  }

  @override
  Future<void> delete(String id) {
    return firestoreDelete(id);
  }

  @override
  Future<Activation> findByCode(String code) {
    return firestoreFindByParam<String>(
        firestore, collection, activationModelBuilder, "code", code);
  }

  @override
  Future<Activation> findByID(String id) {
    return firestoreGetById(id, activationModelBuilder);
  }

  @override
  Future<Activation> findByUID(String uid) {
    return firestoreFindByParam<String>(
        firestore, collection, activationModelBuilder, "uid", uid);
  }

  @override
  Future<void> update(String id, Activation model) {
    return firestoreUpdate(id, model);
  }
}
