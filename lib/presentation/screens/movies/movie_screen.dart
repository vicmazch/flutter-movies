import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sec_twelve_app/domain/entities/actor.dart';
import 'package:sec_twelve_app/domain/entities/movie.dart';
import 'package:sec_twelve_app/presentation/providers/providers.dart';

class MovieScreen extends ConsumerStatefulWidget {

  static const name = 'movie-screen';

  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {

  @override
  void initState() {
    super.initState();

    ref.read(movieDetailProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).getActorsByMovieId(widget.movieId);
  }


  @override
  Widget build(BuildContext context) {
    final Map<String, Movie> movies = ref.watch(movieDetailProvider);
    final Movie? movie = movies[widget.movieId];

    if( movie == null ) {
      return const Scaffold( body: Center(child: CircularProgressIndicator()),);
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSilverAppBar(movie: movie,),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _MovieDetail(movie: movie,);
              },
              childCount: 1
            )
          )
        ],
      )
    );
  }
}

class _MovieDetail extends StatelessWidget {
  final Movie movie;
  const _MovieDetail({
    // super.key, 
    required this.movie
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.3,
                ),
              ),

              const SizedBox(width: 10,),

              SizedBox(
                width: (size.width -50) * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text( movie.title, style: textStyles.titleLarge,),
                    const SizedBox( height: 10,),
                    Text( movie.overview, style: textStyles.bodySmall,),
                  ],
                ),
              ),

            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(10),
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            children: [
              ...movie.genreIds.map((gender) => Container(
                margin: const EdgeInsets.only(right: 10), 
                child: Chip(
                  label: Text(gender),
                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20)),
                ),
                
                
              ))
            ],
          ),
        ),

        _ActorsByMovie(movieId: movie.id.toString(),),
        
        const SizedBox(height: 50,),
      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;
  const _ActorsByMovie({ required this.movieId });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final Map<String, List<Actor>> actorsByMovie = ref.watch(actorsByMovieProvider);
    final List<Actor>? actors = actorsByMovie[movieId];

    if( actors == null ) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];

          return Container(
            padding: const EdgeInsets.all(10),
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInRight(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      actor.profilePath,
                      height: 180,
                      width: 135,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox( height: 5,),
                Text( 
                  actor.name,
                  maxLines: 2,
                ),
                Text(
                  actor.character ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CustomSilverAppBar extends ConsumerWidget {
  final Movie movie;

  const _CustomSilverAppBar({
    // super.key, 
    required this.movie
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final size = MediaQuery.of(context).size;
    final AsyncValue isfavoriteFuture = ref.watch( isFavoriteProvider(movie.id) );

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () async {
            // ref.read( localStorageRepositoryProvider ).toggleFavorite(movie),
            await ref.read( favoriteMoviesProvider.notifier ).toggleFavorite(movie);
            ref.invalidate(isFavoriteProvider(movie.id));
          }, 
          icon: isfavoriteFuture.when(
            data: (isFavorite) => isFavorite
              ? Icon(Icons.favorite_rounded, color: Colors.pink.shade700, size: 27,)
              : const Icon(Icons.favorite_border_outlined, size: 27,), 
            error: (_, __) => throw UnimplementedError(), 
            loading: () => const CircularProgressIndicator()
          )
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if( loadingProgress != null ) return const SizedBox();
                  return FadeIn(child: child);
                },
              ),
            ),

            const _CustomGradient(
              begin: Alignment.bottomCenter, 
              end: Alignment.center, 
              colors: [Colors.black38, Colors.transparent], 
              stops: [0.0, 0.5],
            ),

            const _CustomGradient(
              begin: Alignment.topCenter, 
              end: Alignment.center, 
              colors: [Colors.black87, Colors.transparent, ], 
              stops: [0.0, 0.6],
            ),
          ]
        ),
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        title: const Text(
          '',//movie.title,
          style: TextStyle( fontSize: 20),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double> stops;
  final List<Color> colors;
  
  const _CustomGradient({
    required this.begin, 
    required this.end, 
    required this.stops, 
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            stops: stops,
            colors: colors
          )
        )
      ),
    );
  }
}