import 'package:ikonfete/firebase_repository/firebase_repository.dart';
import 'package:ikonfete/model/settings.dart';
import 'package:ikonfete/repository/settings_repository.dart';

class FirebaseSettingsRepository extends FirestoreRepository<Settings>
    implements SettingsRepository {
  final ModelBuilder<Settings> modelBuilder =
      (Map<String, dynamic> data) => Settings()..fromJson(data);

  FirebaseSettingsRepository([String collection = "settings"])
      : super(collection);

  @override
  Future<Settings> create(Settings model) {
    return firestoreCreate(model);
  }

  @override
  Future<void> delete(String id) {
    return firestoreDelete(id);
  }

  @override
  Future<Settings> findByID(String id) {
    return firestoreGetById(id, modelBuilder);
  }

  @override
  Future<Settings> findByUid(String uid) {
    return firestoreFindByParam(
        firestore, collection, modelBuilder, "uid", uid);
  }

  @override
  Future<void> update(String id, Settings model) {
    return firestoreUpdate(id, model);
  }
}
