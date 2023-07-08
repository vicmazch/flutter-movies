import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sec_twelve_app/presentation/delegates/search_movie_delegate.dart';
import 'package:sec_twelve_app/presentation/providers/providers.dart';

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Icon(Icons.movie_outlined, color: colors.primary,),
              const SizedBox( width: 5,),
              Text('Cinemierda...', style: titleStyle,),
              const Spacer(),
              IconButton(
                onPressed: () async {

                  // final movieRepository = ref.read(movieRepositoryProvider);
                  final searchMovies = ref.read(searchMoviesProvider);
                  final searchQuery = ref.read(searchQueryProvider);
                  
                  showSearch(
                    query: searchQuery,
                    context: context, 
                    delegate: SearchMovieDelegate(
                      initialMovies: searchMovies,
                      searchMovies: ref.read(searchMoviesProvider.notifier).searchMoviesByQuery
                      // searchMovies: ( query ) {
                      //   ref.read(searchQueryProvider.notifier).update((state) => query);
                      //   return movieRepository.searchMovie(query);
                      // },
                    )
                  ).then((movie) {
                    if( movie == null ) return;

                    context.push('/home/0/movie/${ movie.id }');
                  },);
                }, 
                icon: const Icon(Icons.search)
              )
            ],
          ),
        ),
      ),
    );
  }
}