import 'package:ikonfete/firebase_repository/firebase_repository.dart';
import 'package:ikonfete/model/pending_verification.dart';
import 'package:ikonfete/repository/pending_verification_repository.dart';

class FirebasePendingVerificationRepository
    extends FirestoreRepository<PendingVerification>
    implements PendingVerificationRepository {
  final String artistCollection = "artists";

  final ModelBuilder<PendingVerification> pendingVerificationBuilder =
      (Map<String, dynamic> data) => PendingVerification()..fromJson(data);

  FirebasePendingVerificationRepository(
      [String collection = "pending_verifications"])
      : super(collection);

  @override
  Future<PendingVerification> create(PendingVerification model) {
    return firestoreCreate(model);
  }

  @override
  Future delete(String id) {
    return firestoreDelete(id);
  }

  @override
  Future<PendingVerification> findByID(String id) {
    return firestoreGetById(id, pendingVerificationBuilder);
  }

  @override
  Future update(String id, PendingVerification model) {
    return firestoreUpdate(id, model);
  }
}
