import 'package:ikonfete/model/artist.dart';
import 'package:ikonfete/model/fan.dart';
import 'package:ikonfete/repository/repository.dart';

abstract class ArtistRepository implements Repository<Artist, String> {
  Future<Artist> findByUID(String uid);

  Future<Artist> findByUsername(String username);

  Future<Artist> findByEmail(String email);

  Future<List<Artist>> searchByNameOrUsername(String query);

  Future<bool> addTeamMember(String artistId, String fanId);
}
