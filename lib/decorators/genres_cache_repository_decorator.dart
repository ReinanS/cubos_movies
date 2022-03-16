import 'dart:convert';

import 'package:cubos_movies/core/errors/movie.error.dart';
import 'package:cubos_movies/decorators/genres_repository_decorator.dart';
import 'package:cubos_movies/models/movie_genre.dart';
import 'package:cubos_movies/repositories/genres/genres_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenresCacheRepositoryDecorator extends GenresRepositoryDecorator {
  GenresCacheRepositoryDecorator(GenresRepository genresRepository)
      : super(genresRepository);

  @override
  Future<Either<MovieError, List<MovieGenre>>> getGenres() async {
    List<MovieGenre> genres = [];

    final result = await super.getGenres();

    result.fold(
      (error) {},
      (g) => genres.addAll(g),
    );

    if (result.isLeft()) return Right(await _getInCache());

    _saveInCache(genres);
    return Right(genres);
  }

  Future<void> _saveInCache(List<MovieGenre> genres) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonGenres = jsonEncode(genres.map((g) => g.toJson()).toList());
    prefs.setString('genres_cache', jsonGenres);
    print('Salvou no cache os gêneros');
  }

  Future<List<MovieGenre>> _getInCache() async {
    final prefs = await SharedPreferences.getInstance();
    final genresJsonString = prefs.getString('genres_cache');

    if (genresJsonString == null) throw Exception('Cache não encontrado');

    var json = jsonDecode(genresJsonString) as List;

    List<MovieGenre> genresList =
        json.map((d) => MovieGenre.fromJson(d)).toList();

    print('Recuperou do cache os gêneros ');
    return genresList;
  }
}
