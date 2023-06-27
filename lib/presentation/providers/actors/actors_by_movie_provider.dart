



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sec_twelve_app/domain/entities/actor.dart';
import 'package:sec_twelve_app/presentation/providers/actors/actors_repository_provider.dart';


//** ID_MOVIE -> LIST<ACTOR>, VA PERMITIR INTEGRAR CACHE Y
  //* VALIDAR SI YA EXISTE LA 'MOVIE'
  // {
  //   '9492374': List<Actor>,
  //   '4324330': List<Actor>,
  //   '6456632': List<Actor>,
  //   ...
  // }
// */

typedef GetActorsCallback = Future<List<Actor>>Function(String movieId);

final actorsByMovieProvider = StateNotifierProvider<ActorsByMovieIdMapNotifier, Map<String, List<Actor>>>((ref) {
  final actorsRepository = ref.watch(actorsRepositoryProvider).getActorByMovie;

  return ActorsByMovieIdMapNotifier(fetchActors: actorsRepository);
});



class ActorsByMovieIdMapNotifier extends StateNotifier<Map<String, List<Actor>>> {
  
  GetActorsCallback fetchActors;
  
  ActorsByMovieIdMapNotifier({
    required this.fetchActors
  }): super({/** INICIALIZA CON UN MAPA VACIO */});

  Future<void> getActorsByMovieId( String movieId ) async {
    if( state[movieId] != null ) return;

    debugPrint(':::: GET ACTORS BY MOVIE... ${state.length}');

    final actors = await fetchActors(movieId);
    state = { ...state, movieId : actors };
  }
}