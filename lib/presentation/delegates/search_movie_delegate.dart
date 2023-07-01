

import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sec_twelve_app/config/helpers/human_formats.dart';
import 'package:sec_twelve_app/domain/entities/movie.dart';


typedef SearchMovieCallback = Future<List<Movie>> Function( String query );

class SearchMovieDelegate extends SearchDelegate<Movie?> {

  final SearchMovieCallback searchMovies;
  StreamController<List<Movie>> debounceMovie = StreamController.broadcast();
  Timer? _debounceTimer;

  SearchMovieDelegate({
    required this.searchMovies
  });

  void _clearStream() {
    debounceMovie.close();
  }
  void _onQueryChanged( String query ){

    debugPrint( 'Query string cambio... ');

    if( _debounceTimer?.isActive ?? false ) {
      _debounceTimer!.cancel();
    } 

    _debounceTimer = Timer( const Duration(milliseconds: 500), () async {
      debugPrint( 'Buscando peliculas... ');

      if( query.isEmpty ) {
        debounceMovie.add([]);
      }
      
      final movies = await searchMovies(query);
      debounceMovie.add(movies);
    } );
  }

  @override
  String get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      FadeIn(
        animate: query.isNotEmpty,
        child: IconButton(
          onPressed: () => query = '', 
          icon: const Icon(Icons.clear_rounded)
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null), 
      icon: const Icon(Icons.arrow_back_outlined)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    // return FutureBuilder(
    return StreamBuilder(
      // future: searchMovies(query),
      stream: debounceMovie.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];

            return _MovieItem(movie: movie, onMovieSelected: (context, movie) {
              _clearStream();
              close(context, movie);
            },);
          },
        );
      },
    );
  }
  
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;
  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => onMovieSelected(context, movie),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
    
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network( 
                  movie.posterPath,
                  loadingBuilder: (context, child, loadingProgress) => FadeIn(child: child),
               ),
              ),
            ),
    
            const SizedBox( width: 10,),
    
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text( movie.title, style: textStyles.titleMedium,),
                  movie.overview.length > 100 
                  ? Text('${movie.overview.substring(0,100)}...')
                  : Text( movie.overview ),
    
                  Row(
                    children: [
                      Icon(Icons.star_half_outlined, color: Colors.yellow.shade700,),
                      const SizedBox( width: 5,),
                      Text(
                        HumanFormats.number(movie.voteAverage, 1),
                        style: textStyles.bodyMedium?.copyWith(color: Colors.yellow.shade700, fontWeight: FontWeight.bold)
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}