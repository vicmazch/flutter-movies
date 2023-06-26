import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sec_twelve_app/config/helpers/human_formats.dart';
import 'package:sec_twelve_app/domain/entities/movie.dart';

class MovieHorizontalListview extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final String? subTitle;
  final VoidCallback? loadNextPage;

  const MovieHorizontalListview({
    super.key, 
    required this.movies, 
    this.title, 
    this.subTitle, 
    this.loadNextPage
  });

  @override
  State<MovieHorizontalListview> createState() => _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {

  final scrollController = ScrollController();

  @override
  void initState() {

    scrollController.addListener(() {
      if( widget.loadNextPage == null ) return;

      if( (scrollController.position.pixels + 20) >=  scrollController.position.maxScrollExtent)  {
        widget.loadNextPage!();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          
          if(widget.title != null || widget.subTitle != null) _Title(title: widget.title, subTitle: widget.subTitle,),

          Expanded(
            child:  ListView.builder(
              controller: scrollController,
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return FadeIn(child: _Slide(movie: widget.movies[index],));
              },
            )
          ),

        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;
  const _Slide({
    // super.key, 
    required this.movie
  });

  @override
  Widget build(BuildContext context) {

  final textStyle = Theme.of(context).textTheme;

    return Container(
      // color: Colors.amber,
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // * IMAGE...
          SizedBox(
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                height: 220,
                // width: 150,
                loadingBuilder: (context, child, loadingProgress) {
                  if( loadingProgress != null ) {
                    return  const SizedBox( height: 150, child: Center(child: CircularProgressIndicator( strokeWidth: 2,),));
                  }
                  return GestureDetector(
                    child: FadeIn(child: child),
                    onTap: () => context.push('/movie/${ movie.id }'),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 5,),
          
          // * TITLE
          SizedBox(
            width: 150,
            child: Text(
              movie.title,
              maxLines: 1,
              style: textStyle.titleSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // * RATING
          SizedBox(
            width: 150,
            child: Row(
              children: [
                Icon(Icons.star_half_outlined, color: Colors.yellow.shade800,),
                Text(
                  '${ movie.voteAverage }',
                  style: textStyle.bodyMedium?.copyWith( color: Colors.yellow.shade800),
                ),
                // const SizedBox( width: 10,),
                const Spacer(),
                Text(
                  HumanFormats.number(movie.popularity),
                  style: textStyle.bodySmall,
                )
              ],
            ),
          )




        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String? title;
  final String? subTitle;

  const _Title({
    // super.key, 
    this.title, 
    this.subTitle
  });

  @override
  Widget build(BuildContext context) {

    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if(title != null) Text(title!, style: titleStyle,),

          const Spacer(),

          if(subTitle != null) 
            FilledButton.tonal(
              style: const ButtonStyle( visualDensity: VisualDensity.compact),
              onPressed: () {  }, 
              child: Text(subTitle!)
            )
        ],
      ),
    );
  }
}