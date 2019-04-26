import 'package:firebase_database/firebase_database.dart';
import 'package:ikonfete/firebase_repository/firebase_repository.dart';
import 'package:ikonfete/model/presence.dart';
import 'package:ikonfete/repository/user_presence_repository.dart';

class FirebaseUserPresenceRepository extends FirestoreRepository<UserPresence>
    implements UserPresenceRepository {
  final modelBuilder =
      (Map<String, dynamic> data) => UserPresence()..fromJson(data);
  final FirebaseDatabase firebaseDatabase;

  FirebaseUserPresenceRepository([String collection = "user_presence"])
      : firebaseDatabase = FirebaseDatabase.instance,
        super(collection);

  @override
  Future<UserPresence> create(UserPresence model) {
    return firestoreCreate(model);
  }

  @override
  Future<void> delete(String id) {
    return firestoreDelete(id);
  }

  @override
  Future<UserPresence> findByID(String id) {
    return firestoreGetById(id, modelBuilder);
  }

  @override
  Future<void> update(String id, UserPresence model) {
    return firestoreUpdate(id, model);
  }

  @override
  Future<void> registerPresence(UserPresence presence) async {
    if (presence.id == null || presence.id.isEmpty) {
      firestoreCreate(presence);
    } else {
      firestoreUpdate(presence.id, presence);
    }

    firebaseDatabase.reference().child("/status/${presence.uid}").set('online');

    firebaseDatabase
        .reference()
        .child("/status/${presence.uid}")
        .onDisconnect()
        .set('offline');

    // todo: listen on firebase .info/connected
  }

  @override
  Future<UserPresence> findByUid(String uid) {
    return firestoreFindByParam(
        firestore, collection, modelBuilder, "uid", uid);
  }
}
