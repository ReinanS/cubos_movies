import 'package:cubos_movies/errors/movie.error.dart';
import 'package:cubos_movies/model/movie_genre.dart';
import 'package:cubos_movies/model/movie_model.dart';
import 'package:cubos_movies/model/movie_response_model.dart';
import 'package:cubos_movies/repositories/movies/movie_repository.dart';
import 'package:cubos_movies/repositories/movies/movies_repository.dart';
import 'package:dartz/dartz.dart';

class MovieController {
  final MoviesRepository _movieRepository;

  MovieController(this._movieRepository);

  MovieResponseModel? movieResponseModel;
  MovieError? movieError;
  bool loading = true;

  List<MovieModel> get movies => movieResponseModel?.movies ?? <MovieModel>[];
  int get moviesCount => movies.length;
  bool get hasMovies => moviesCount != 0;
  int get totalPages => movieResponseModel?.totalPages ?? 1;
  int get currentPage => movieResponseModel?.page ?? 1;

  Future<Either<MovieError, MovieResponseModel>> fetchMoviesByGenre(
      {int page = 1, required int genre}) async {
    movieError = null;
    final result = await _movieRepository.getMovieByGenre(page, genre);
    result.fold(
      (error) => movieError = error,
      (movie) {
        if (movieResponseModel == null) {
          movieResponseModel = movie;
        } else {
          movieResponseModel?.page = movie.page;
          movieResponseModel?.movies?.addAll(movie.movies!);
        }
      },
    );

    return result;
  }

  Future<Either<MovieError, MovieResponseModel>> fetchMovieByName(
      {int page = 1, required String query}) async {
    movieError = null;
    final result = await _movieRepository.getMoviesByname(page, query);
    result.fold(
      (error) => movieError = error,
      (movie) {
        if (movieResponseModel == null) {
          movieResponseModel = movie;
        } else {
          movieResponseModel?.page = movie.page;
          movieResponseModel?.movies?.addAll(movie.movies!);
        }
      },
    );

    return result;
  }

  String movieGenderPoster(MovieModel movie, List<MovieGenre> genres) {
    String posterGenres = '';

    for (int index = 0; index < movie.genreIds!.length; index++) {
      if (index == movie.genreIds!.length - 1) {
        posterGenres += genres
            .firstWhere((genre) => genre.id == movie.genreIds![index])
            .name!;
      } else {
        posterGenres += (genres
                .firstWhere((genre) => genre.id == movie.genreIds![index])
                .name! +
            ' - ');
      }
    }

    return posterGenres;
  }
}
