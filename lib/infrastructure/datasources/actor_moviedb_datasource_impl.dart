

import 'package:dio/dio.dart';
import 'package:sec_twelve_app/config/constants/environment.dart';
import 'package:sec_twelve_app/domain/datasources/actors_datasource.dart';
import 'package:sec_twelve_app/domain/entities/actor.dart';
import 'package:sec_twelve_app/infrastructure/mappers/actor_mapper.dart';
import 'package:sec_twelve_app/infrastructure/models/moviedb/credits_response.dart';

class ActorMovieDbDatasourceImpl extends ActorDatasource {
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
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final response = await dio.get(
      '/movie/$movieId/credits',
    );

    if( response.statusCode != 200 ) throw Exception('Credits with id: $movieId not found.');

    final CreditsResponse creditsResponse = CreditsResponse.fromJson(response.data);
    final List<Cast> listCast = creditsResponse.cast;
    final List<Actor> actors  = listCast.map((cast) => ActorMapper.castToActor(cast)).toList();
      
    return actors;
  }
  
}