import 'package:firebase_database/firebase_database.dart';
import 'package:ikonfete/firebase_repository/firebase_repository.dart';
import 'package:ikonfete/model/artist.dart';
import 'package:ikonfete/repository/artist_repository.dart';

class FirebaseArtistRepository extends FirestoreRepository<Artist>
    implements ArtistRepository {
  final ModelBuilder<Artist> artistModelBuilder =
      (Map<String, dynamic> data) => Artist()..fromJson(data);
  final FirebaseDatabase _firebaseDatabase;

  FirebaseArtistRepository([String collection = "artists"])
      : _firebaseDatabase = FirebaseDatabase.instance,
        super(collection);

  @override
  Future<Artist> create(Artist model) async {
    model.dateCreated = DateTime.now().toUtc();
    final artist = await firestoreCreate(model);
    await _firebaseDatabase
        .reference()
        .child(collection)
        .child(artist.id)
        .set(model.toJson());
    return artist;
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
  Future<Artist> findByEmail(String email) async {
    return firestoreFindByParam<String>(
        firestore, collection, artistModelBuilder, "email", email);
  }

  @override
  Future<Artist> findByID(String id) {
    return firestoreGetById(id, artistModelBuilder);
  }

  @override
  Future<Artist> findByUID(String uid) {
    return firestoreFindByParam<String>(
        firestore, collection, artistModelBuilder, "uid", uid);
  }

  @override
  Future<Artist> findByUsername(String username) {
    return firestoreFindByParam<String>(
        firestore, collection, artistModelBuilder, "username", username);
  }

  @override
  Future update(String id, Artist model) async {
    model.dateUpdated = DateTime.now().toUtc();
    await firestoreUpdate(id, model);
    await _firebaseDatabase
        .reference()
        .child(collection)
        .child(id)
        .update(model.toJson());
    return;
  }
}
