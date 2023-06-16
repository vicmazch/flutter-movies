

import 'package:sec_twelve_app/domain/entities/movie.dart';

abstract class MovieRepository {

  Future<List<Movie>> getNowPlaying({ int page = 1});
  
}