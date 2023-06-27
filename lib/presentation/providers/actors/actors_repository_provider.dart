
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sec_twelve_app/infrastructure/datasources/actor_moviedb_datasource_impl.dart';
import 'package:sec_twelve_app/infrastructure/repositories/actor_repository_impl.dart';

// * REPOSITORIO INMUTABLE
final actorsRepositoryProvider = Provider((ref) {
  return ActorRepositoryImpl( ActorMovieDbDatasourceImpl() );
});