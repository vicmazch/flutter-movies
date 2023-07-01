

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sec_twelve_app/domain/entities/movie.dart';
import 'package:sec_twelve_app/presentation/delegates/search_movie_delegate.dart';
import 'package:sec_twelve_app/presentation/providers/providers.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchMoviesProvider = StateNotifierProvider<SearchMoviesNotifier, List<Movie>>((ref) {
  final movieRepository = ref.read(movieRepositoryProvider);

  return SearchMoviesNotifier(searchMovies: movieRepository.searchMovie, ref: ref);
});


typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMoviesNotifier extends StateNotifier<List<Movie>> {
  
  final SearchMovieCallback searchMovies;
  final Ref ref;

  SearchMoviesNotifier({
    required this.searchMovies,
    required this.ref
  }): super([]);

  Future<List<Movie>> searchMoviesByQuery( String query ) async {
    final List<Movie> movies = query.isEmpty ? [] : await searchMovies(query);
    // final List<Movie> movies = await searchMovies(query);

    ref.read(searchQueryProvider.notifier).update((state) => query);
    
    state = movies;

    return movies;
  }



  
  
}