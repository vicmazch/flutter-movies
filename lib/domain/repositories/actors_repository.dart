

import 'package:sec_twelve_app/domain/entities/actor.dart';

abstract class ActorsRepository {

  Future<List<Actor>> getActorByMovie( String movieId );

}