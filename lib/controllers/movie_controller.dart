import 'package:cubos_movies/errors/movie.error.dart';
import 'package:cubos_movies/model/movie_genre.dart';
import 'package:cubos_movies/model/movie_model.dart';
import 'package:cubos_movies/model/movie_response_model.dart';
import 'package:cubos_movies/repositories/genre_repository.dart';
import 'package:cubos_movies/repositories/movie_repository.dart';
import 'package:dartz/dartz.dart';

class MovieController {
  final _movieRepository = MovieRepository();
  final _genreRespository = GenreRepository();

  MovieResponseModel? movieResponseModel;
  MovieError? movieError;
  bool loading = true;

  List<MovieModel> get movies => movieResponseModel?.movies ?? <MovieModel>[];
  int get moviesCount => movies.length;
  bool get hasMovies => moviesCount != 0;
  int get totalPages => movieResponseModel?.totalPages ?? 1;
  int get currentPage => movieResponseModel?.page ?? 1;

  List<MovieGenre>? _genres;

  List<MovieGenre> get genres => _genres ?? <MovieGenre>[];
  int get genresCount => genres.length;
  bool get hasGenres => genresCount != 0;

  Future<void> initPageController() async {
    final movies = await this.fetchAllMovies();
    final genres = await this.fetchAllGenres();
  }

  Future<Either<MovieError, MovieResponseModel>> fetchAllMovies(
      {int page = 1}) async {
    movieError = null;
    final result = await _movieRepository.fetchAllMovies(page);
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

  Future<Either<MovieError, List<MovieGenre>>> fetchAllGenres() async {
    movieError = null;

    final result = await _genreRespository.fetchAllGenres();

    result.fold(
      (error) => movieError = error,
      (genres) {
        if (_genres == null) {
          _genres = genres;
        } else {
          _genres?.addAll(genres);
        }
      },
    );

    return result;
  }

  String movieGenderPoster(MovieModel movie) {
    String posterGenres = '';

    for (int index = 0; index < movie.genreIds!.length; index++) {
      if (index == movie.genreIds!.length - 1) {
        posterGenres += _genres!
            .firstWhere((genre) => genre.id == movie.genreIds![index])
            .name!;
      } else {
        posterGenres += (_genres!
                .firstWhere((genre) => genre.id == movie.genreIds![index])
                .name! +
            ' - ');
      }
    }

    return posterGenres;
  }
}
