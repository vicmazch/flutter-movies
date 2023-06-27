


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sec_twelve_app/infrastructure/datasources/moviedb_datasource_impl.dart';
import 'package:sec_twelve_app/infrastructure/repositories/movie_repository_impl.dart';

// * REPOSITORIO INMUTABLE
final movieRepositoryProvider = Provider((ref) {
  return MovieRepositoryImpl( MovieDbDatasourceImpl() );
});