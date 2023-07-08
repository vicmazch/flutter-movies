import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sec_twelve_app/domain/entities/movie.dart';
import 'package:sec_twelve_app/presentation/providers/storage/favorite_movies_providers.dart';
import 'package:sec_twelve_app/presentation/widgets/widgets.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {
  bool isLoading = false;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();

    loadNextPage();
  }

  void loadNextPage() async {

    if(isLoading || isLastPage) return;

    isLoading = true;

    final movies = await ref.read(favoriteMoviesProvider.notifier).loadNextPage();

    isLoading = false;

    if( movies.isEmpty ) {
      isLastPage = true;
    }

  }

  @override
  Widget build(BuildContext context) {

    final Map<int, Movie> favoritesMoviesMap = ref.watch(favoriteMoviesProvider);
    List<Movie> favoritesMovies = favoritesMoviesMap.values.toList();

    // favoritesMoviesMap.forEach((key, value) {
    //   favoritesMovies.add(value);
    // });

    if( favoritesMovies.isEmpty ) {
      final colors = Theme.of(context).colorScheme;

      return Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border_sharp, size: 60, color: colors.primary,),
              Text('Ohhh no!!', style: TextStyle( fontSize: 30, color: colors.primary),),
              const Text('No tienes películas favoritas', style: TextStyle( fontSize: 20, color: Colors.black45),),
              const SizedBox( height: 20,),
              FilledButton.tonal(onPressed: () => context.go('/home/0'), child: const Text('Empieza a buscar'))
            ],
          )
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites View'),
      ),
      body: MovieMasonry(movies: favoritesMovies, loadNextPage: loadNextPage),
      // body: ListView.builder(
      //   itemCount: favoritesMovies.length,
      //   itemBuilder: (context, index) {
      //     final movie = favoritesMovies[index];
      //     return ListTile(
      //       title: Text(movie.title),
      //     );
      //   },
      // ),
    );
  }
}