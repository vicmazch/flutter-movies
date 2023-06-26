

import 'package:sec_twelve_app/domain/entities/movie.dart';
import 'package:sec_twelve_app/infrastructure/models/moviedb/movie_detail.dart';
import 'package:sec_twelve_app/infrastructure/models/moviedb/movie_from_moviedb.dart';

const pathUrlImageMovieDB = 'https://image.tmdb.org/t/p/w500';
const pathImageNotFound = 'https://media.wired.com/photos/5a0201b14834c514857a7ed7/master/w_2560%2Cc_limit/1217-WI-APHIST-01.jpg';

class MovieMapper {

  static Movie movieDbToEntity( MovieFromMovieDB movie ) => Movie(
      adult: movie.adult,
      backdropPath: movie.backdropPath != '' ? '$pathUrlImageMovieDB${movie.backdropPath}' : pathImageNotFound,
      genreIds: movie.genreIds.map((m) => m.toString()).toList(),
      id: movie.id,
      originalLanguage: movie.originalLanguage,
      originalTitle: movie.originalTitle,
      overview: movie.overview,
      popularity: movie.popularity,
      posterPath: movie.posterPath != '' ? '$pathUrlImageMovieDB${movie.posterPath}' : 'no-poster',
      releaseDate: movie.releaseDate,
      title: movie.title,
      video: movie.video,
      voteAverage: movie.voteAverage,
      voteCount: movie.voteCount);

  static Movie movieDetailToEntity( MovieDetail movie ) => Movie(
      adult: movie.adult,
      backdropPath: movie.backdropPath != '' ? '$pathUrlImageMovieDB${movie.backdropPath}' : pathImageNotFound,
      genreIds: movie.genres.map((g) => g.name).toList(),
      id: movie.id,
      originalLanguage: movie.originalLanguage,
      originalTitle: movie.originalTitle,
      overview: movie.overview,
      popularity: movie.popularity,
      posterPath: movie.posterPath != '' ? '$pathUrlImageMovieDB${movie.posterPath}' : 'no-poster',
      releaseDate: movie.releaseDate,
      title: movie.title,
      video: movie.video,
      voteAverage: movie.voteAverage,
      voteCount: movie.voteCount);
}