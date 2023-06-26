



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sec_twelve_app/domain/entities/movie.dart';
import 'package:sec_twelve_app/presentation/providers/movies/movies_repository_provider.dart';


//** ID_MOVIE -> MOVIE(), VA PERMITIR INTEGRAR CACHE Y
  //* VALIDAR SI YA EXISTE LA 'MOVIE'
  // {
  //   '9492374': Movie(...),
  //   '4324330': Movie(...),
  //   '6456632': Movie(...),
  //   ...
  // }
// */

typedef GetMovieCallback = Future<Movie>Function(String movieId);

final movieDetailProvider = StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
  final fetchMovie = ref.watch(movieRepositoryProvider).getMovieById;
  return MovieMapNotifier(fetchMovie: fetchMovie);
});



class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  
  GetMovieCallback fetchMovie;
  
  MovieMapNotifier({
    required this.fetchMovie
  }): super({/** INICIALIZA CON UN MAPA VACIO */});

  Future<void> loadMovie( String movieId ) async {
    if( state[movieId] != null ) return;

    debugPrint(':::: GET MOVIE... ${state.length}');

    final movie = await fetchMovie(movieId);
    state = { ...state, movieId : movie };
  }
}