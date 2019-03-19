import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ikonfete/model/model.dart';

typedef M ModelBuilder<M extends Model>(Map<String, dynamic> data);

abstract class FirestoreRepository<M extends Model> {
  Firestore firestore;
  String collection;

  FirestoreRepository(String collection) {
    this.collection = collection;
    firestore = Firestore.instance;
  }

  Future<M> firestoreCreate(M model) async {
    final docref = firestore.collection(collection).document();
    model.id = docref.documentID;
    await docref.setData(model.toJson());
    return model;
  }

  Future<M> firestoreGetById(String id, ModelBuilder<M> modelBuilder) async {
    final docref = firestore.collection(collection).document(id);
    final snapshot = await docref.get();
    if (snapshot == null) {
      return null;
    }

    M model = modelBuilder(snapshot.data);
    model.id = snapshot.documentID;
    return model;
  }

  Future firestoreDelete(String id) async {
    final docref = firestore.collection(collection).document(id);
    await docref.delete();
    return;
  }

  Future firestoreUpdate(String id, M model) async {
    final docref = firestore.collection(collection).document(id);
    if ((await docref.get()) == null) {
      throw ArgumentError("Fan with id $id not found");
    }

    await docref.updateData(model.toJson());
  }

  Future<M> firestoreFindByParam<T>(
    Firestore firestore,
    String collection,
    ModelBuilder<M> modelBuilder,
    String paramName,
    T paramVal,
  ) async {
    final query =
        firestore.collection(collection).where(paramName, isEqualTo: paramVal);
    final querySnapshot = await query.getDocuments();
    if (querySnapshot.documents.isEmpty) {
      return null;
    }
    final docSnapshot = querySnapshot.documents.first;
    M model = modelBuilder(docSnapshot.data);
    model.id = docSnapshot.documentID;
    return model;
  }
}
