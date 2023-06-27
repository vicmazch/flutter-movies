import 'package:sec_twelve_app/domain/datasources/actors_datasource.dart';
import 'package:sec_twelve_app/domain/entities/actor.dart';
import 'package:sec_twelve_app/domain/repositories/actors_repository.dart';

class ActorRepositoryImpl extends ActorsRepository {
  final ActorDatasource actorDatasource;

  ActorRepositoryImpl(this.actorDatasource);

  @override
  Future<List<Actor>> getActorByMovie(String movieId) {
    return actorDatasource.getActorsByMovie(movieId);
  }
  
}