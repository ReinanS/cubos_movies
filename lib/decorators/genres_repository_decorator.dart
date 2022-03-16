import 'package:cubos_movies/core/errors/movie.error.dart';
import 'package:cubos_movies/models/movie_genre.dart';
import 'package:cubos_movies/repositories/genres/genres_repository.dart';
import 'package:dartz/dartz.dart';

class GenresRepositoryDecorator extends GenresRepository {
  // RECEBE UMA INSTÂNCIA VIA INJEÇÃO DE CONTROLE DE DEPENDÊNCIA
  final GenresRepository _genresRepository;
  GenresRepositoryDecorator(this._genresRepository);

  @override
  Future<Either<MovieError, List<MovieGenre>>> getGenres() {
    return _genresRepository.getGenres();
  }
}
