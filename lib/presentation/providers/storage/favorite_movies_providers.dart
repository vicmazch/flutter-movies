

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sec_twelve_app/domain/entities/movie.dart';
import 'package:sec_twelve_app/domain/repositories/local_storage_repository.dart';
import 'package:sec_twelve_app/presentation/providers/providers.dart';

final isFavoriteProvider = FutureProvider.family.autoDispose((ref, int movieId){
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return localStorageRepository.isMovieFavorite(movieId);
});


/// {
///  123: Movie,
///  21: Movie,
///  ...
///  
/// }
final favoriteMoviesProvider = StateNotifierProvider<StorageMoviesNotifier, Map<int,Movie>>((ref){
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return StorageMoviesNotifier(localStorageRepository: localStorageRepository);
});


class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;

  StorageMoviesNotifier({
    required this.localStorageRepository
  }): super({});

  Future<List<Movie>> loadNextPage() async {
    final movies =  await localStorageRepository.loadMovies(offset: page * 10, limit: 20);
    page++;

    final Map<int, Movie> mapMovies = {};

    for (final movie in movies) {
      mapMovies.addAll({movie.id: movie});
    }

    state = { ...state, ...mapMovies };

    return movies;
  }

  Future<void> toggleFavorite( Movie movie )  async {
    await localStorageRepository.toggleFavorite(movie);
    final bool isMovieInFavorites = state[movie.id] != null;

    if( isMovieInFavorites ) {
      state.remove(movie.id);
      state = { ...state };
    } else {
      state = { ...state, movie.id: movie };
    }
  }
}