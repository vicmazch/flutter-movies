
import 'package:dio/dio.dart';

import 'package:sec_twelve_app/config/constants/environment.dart';
import 'package:sec_twelve_app/domain/datasources/movies_datasource.dart';
import 'package:sec_twelve_app/domain/entities/movie.dart';
import 'package:sec_twelve_app/infrastructure/mappers/movie_mapper.dart';
import 'package:sec_twelve_app/infrastructure/models/moviedb/movie_detail.dart';
import 'package:sec_twelve_app/infrastructure/models/moviedb/movie_from_moviedb.dart';
import 'package:sec_twelve_app/infrastructure/models/moviedb/moviedb_response.dart';

class MovieDbDatasourceImpl  extends MoviesDatasource {

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Enviroment.theMovieDBKey,
        'language': 'es-MX'
      }
    )
  );

  @override
  Future<List<Movie>> getNowPlaying({ int page = 1}) async {
    final response = await dio.get(
      '/movie/now_playing',
      queryParameters: {
        'page': page
      }
    );

    if( response.statusCode != 200 ) throw Exception('Movies not found.');

      
    return _jsonToMovies(response.data);
  }
  
  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response = await dio.get(
      '/movie/popular',
      queryParameters: {
        'page': page
      }
    );

    if( response.statusCode != 200 ) throw Exception('Movies not found.');

      
    return _jsonToMovies(response.data);
  }
  
  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response = await dio.get(
      '/movie/upcoming',
      queryParameters: {
        'page': page
      }
    );

    if( response.statusCode != 200 ) throw Exception('Movies not found.');

      
    return _jsonToMovies(response.data);
  }
  
  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response = await dio.get(
      '/movie/top_rated',
      queryParameters: {
        'page': page
      }
    );

    if( response.statusCode != 200 ) throw Exception('Movies not found.');

      
    return _jsonToMovies(response.data);
  }
  
  @override
  Future<Movie> getMovieById( String id) async {
    final response = await dio.get(
      '/movie/$id',
    );

    if( response.statusCode != 200 ) throw Exception('Movie with id: $id not found.');

    final MovieDetail movieDetail = MovieDetail.fromJson(response.data);
    final Movie movie = MovieMapper.movieDetailToEntity(movieDetail);
      
    return movie;
  }





  // *
  List<Movie> _jsonToMovies( Map<String, dynamic> json ) {
    final List<Movie> movies = MovieDbResponse.fromJson(json)
      .results
      .map((MovieFromMovieDB mfmdb) => MovieMapper.movieDbToEntity(mfmdb))
      .where((Movie movie) => movie.posterPath != 'no-poster',)
      .toList();
      
    return movies;
  }
}
