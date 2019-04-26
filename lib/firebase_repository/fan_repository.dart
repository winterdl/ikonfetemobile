import 'dart:async';

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
    final json = model.toJson();
    json["searchableName"] = model.name.toLowerCase();
    json["searchableUsername"] = model.username.toLowerCase();
    await _firebaseDatabase
        .reference()
        .child(collection)
        .child(fan.id)
        .set(json);
    return fan;
  }

  @override
  Future<void> delete(String id) async {
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
  Future<void> update(String id, Fan model) async {
    model.dateUpdated = DateTime.now().toUtc();
    await firestoreUpdate(id, model);
    final json = model.toJson();
    json["searchableName"] = model.name.toLowerCase();
    json["searchableUsername"] = model.username.toLowerCase();
    await _firebaseDatabase
        .reference()
        .child(collection)
        .child(id)
        .update(json);
  }

  @override
  Stream<Fan> streamByUID(String uid) {
    return firestore
        .collection(collection)
        .where("uid", isEqualTo: uid)
        .limit(1)
        .snapshots()
        .map<Fan>((qs) {
      return qs.documents.isEmpty ? null : Fan()
        ..fromJson(qs.documents.first.data);
    });
  }

  @override
  Future<List<Fan>> findByTeamId(String teamId) async {
    final qs = await firestore
        .collection(collection)
        .where("currentTeamId", isEqualTo: teamId)
        .getDocuments();
    final docs = qs.documents;
    if (docs.isEmpty) {
      return [];
    }

    final fans = qs.documents
        .map((docSnapshot) => Fan()..fromJson(docSnapshot.data))
        .toList();
    return fans;
  }

  @override
  Future<void> regsterOnline(String uid) async {
    final fan = await findByUID(uid);
    if (fan == null) return null;
    fan.lastSeen = DateTime.now();
    fan.online = true;
    await update(fan.id, fan);
    await _firebaseDatabase
        .reference()
        .child("/status/fans/$uid")
        .set("online");

    return _firebaseDatabase
        .reference()
        .child("/status/fans/$uid")
        .onDisconnect()
        .set("offline");
    // alternative: listen on firebase .info/connected
  }
}
