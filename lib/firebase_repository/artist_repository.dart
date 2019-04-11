import 'package:firebase_database/firebase_database.dart';
import 'package:ikonfete/firebase_repository/firebase_repository.dart';
import 'package:ikonfete/model/artist.dart';
import 'package:ikonfete/repository/artist_repository.dart';

class FirebaseArtistRepository extends FirestoreRepository<Artist>
    implements ArtistRepository {
  final ModelBuilder<Artist> artistModelBuilder =
      (Map<String, dynamic> data) => Artist()..fromJson(data);
  final FirebaseDatabase _firebaseDatabase;
  final String fanCollection;

  FirebaseArtistRepository(
      [String collection = "artists", String fanCollection = "fans"])
      : _firebaseDatabase = FirebaseDatabase.instance,
        this.fanCollection = fanCollection,
        super(collection);

  @override
  Future<Artist> create(Artist model) async {
    model.dateCreated = DateTime.now().toUtc();
    final artist = await firestoreCreate(model);
    final json = model.toJson();
    json["searchableName"] = model.name.toLowerCase();
    json["searchableUsername"] = model.username.toLowerCase();
    await _firebaseDatabase
        .reference()
        .child(collection)
        .child(artist.id)
        .set(json);
    return artist;
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
  Future<void> update(String id, Artist model) async {
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
    return;
  }

  // todo: only searches by name
  @override
  Future<List<Artist>> searchByNameOrUsername(String query) async {
    DataSnapshot dataSnapshot;
    if (query == null || query.trim().isEmpty) {
      dataSnapshot = await _firebaseDatabase
          .reference()
          .child(collection)
          .orderByChild("searchableName")
          .limitToFirst(20)
          .once();
    } else {
      dataSnapshot = await _firebaseDatabase
          .reference()
          .child(collection)
          .orderByChild("searchableName")
          .startAt(query)
          .endAt(query + "\uf8ff")
          .limitToFirst(20)
          .once();
    }
    final artists = <Artist>[];
    if (dataSnapshot.value != null && dataSnapshot.value.values != null) {
      for (final val in dataSnapshot.value.values) {
        if (val == null) continue;
        artists.add(Artist()..fromJson(val));
      }
    }
    return artists;
  }

  @override
  Future<bool> addTeamMember(String artistId, String fanId) async {
    final artistRef = firestore.collection(collection).document(artistId);
    final fanRef = firestore.collection(fanCollection).document(fanId);

    await firestore.runTransaction((transaction) async {
      await fanRef.updateData({"currentTeamId": artistId});
      final docsnap = await transaction.get(artistRef);
      num teamMemberCount = docsnap.data["teamMemberCount"];
      num newTeamMemberCount = teamMemberCount + 1;
      await transaction
          .update(artistRef, {"teamMemberCount": newTeamMemberCount});

      await _firebaseDatabase
          .reference()
          .child(collection)
          .child(artistId)
          .update({"teamMemberCount": newTeamMemberCount});
      await _firebaseDatabase
          .reference()
          .child(fanCollection)
          .child(fanId)
          .update({"currentTeamId": artistId});
    });

    return true;
  }

  @override
  Stream<Artist> streamByUID(String uid) {
    return firestore
        .collection(collection)
        .where("uid", isEqualTo: uid)
        .limit(1)
        .snapshots()
        .map<Artist>((qs) {
      return qs.documents.isEmpty ? null : Artist()
        ..fromJson(qs.documents.first.data);
    });
  }
}
