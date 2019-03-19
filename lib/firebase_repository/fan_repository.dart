import 'package:firebase_database/firebase_database.dart';
import 'package:ikonfete/firebase_repository/firebase_repository.dart';
import 'package:ikonfete/model/fan.dart';
import 'package:ikonfete/repository/fan_repository.dart';

class FirebaseFanRepository extends FirestoreRepository<Fan>
    implements FanRepository {
  final ModelBuilder<Fan> fanModelBuilder =
      (Map<String, dynamic> data) => Fan()..fromJson(data);
  final FirebaseDatabase _firebaseDatabase;

  FirebaseFanRepository([String collection = "fans"])
      : _firebaseDatabase = FirebaseDatabase.instance,
        super(collection);

  @override
  Future<Fan> create(Fan model) async {
    model.dateCreated = DateTime.now().toUtc();
    final fan = await firestoreCreate(model);
    await _firebaseDatabase
        .reference()
        .child(collection)
        .child(fan.id)
        .set(model.toJson());
    return fan;
  }

  @override
  Future delete(String id) async {
    await firestoreDelete(id);
    await _firebaseDatabase
        .reference()
        .child(collection)
        .child(id)
        .reference()
        .remove();
    return;
  }

  @override
  Future<Fan> findByEmail(String email) {
    return firestoreFindByParam<String>(
        firestore, collection, fanModelBuilder, "email", email);
  }

  @override
  Future<Fan> findByID(String id) {
    return firestoreGetById(id, fanModelBuilder);
  }

  @override
  Future<Fan> findByUID(String uid) {
    return firestoreFindByParam<String>(
        firestore, collection, fanModelBuilder, "uid", uid);
  }

  @override
  Future<Fan> findByUsername(String username) {
    return firestoreFindByParam<String>(
        firestore, collection, fanModelBuilder, "username", username);
  }

  @override
  Future update(String id, Fan model) async {
    model.dateUpdated = DateTime.now().toUtc();
    await firestoreUpdate(id, model);
    await _firebaseDatabase
        .reference()
        .child(collection)
        .child(id)
        .update(model.toJson());
  }
}
