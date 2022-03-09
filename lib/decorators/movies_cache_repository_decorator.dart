import 'dart:convert';
import 'dart:developer';

import 'package:cubos_movies/decorators/movies_repository_decorator.dart';
import 'package:cubos_movies/errors/movie.error.dart';
import 'package:cubos_movies/model/movie_response_model.dart';
import 'package:cubos_movies/repositories/movies/movies_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoviesCacheRepositoryDecorator extends MoviesRepositoryDecorator {
  MoviesCacheRepositoryDecorator(MoviesRepository moviesRepository)
      : super(moviesRepository);

  @override
  Future<Either<MovieError, MovieResponseModel>> getMovieByGenre(
      int page, int genre) async {
    late MovieResponseModel movieResponseModel;

    final result = await super.getMovieByGenre(page, genre);

    result.fold((error) => null, (movies) => movieResponseModel = movies);

    if (result.isLeft()) return _getMovies();

    _saveInCache(movieResponseModel);
    return Right(movieResponseModel);
  }

  Future<void> _saveInCache(MovieResponseModel movieModel) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonMovie = jsonEncode(movieModel.toJson());
    prefs.setString('movies_cache', jsonMovie);
    print('Salvou no cache os filmes');
  }

  Future<Either<MovieError, MovieResponseModel>> _getMovies() async {
    final prefs = await SharedPreferences.getInstance();
    final moviesJsonString = prefs.getString('movies_cache');

    if (moviesJsonString == null)
      return Left(MovieRepositoryError('Cache não encontrado'));

    var json = jsonDecode(moviesJsonString) as String;
    MovieResponseModel movieResponseModel = MovieResponseModel.fromJson(json);

    log('Recuperou o cache dos filmes');
    return Right(movieResponseModel);
  }
}
