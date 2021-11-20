import 'package:cubos_movies/model/movie_genre.dart';
import 'package:cubos_movies/model/movie.dart';
import 'package:cubos_movies/model/movie_detail.dart';
import 'package:cubos_movies/model/services/base_service.dart';
import 'package:cubos_movies/model/services/genre_service.dart';
import 'package:cubos_movies/model/services/movie_detail_service.dart';
import 'package:cubos_movies/model/services/movie_service.dart';

class MovieRepository {
  final String _getMoviesUrl = "/movie/popular";
  final String _getGenresUrl = "/genre/movie/list";
  final String _getMovieDetailUrl = "/movie";

  MovieService _movieService = MovieService();
  BaseService _genreService = GenreService();
  BaseService _movieDetailService = MovieDetailService();

  Future<List<Movie>> fetchMovieList() async {
    dynamic response = await _movieService.getResponse(_getMoviesUrl);
    List<Movie> movieList =
        List.from(response['results']).map((e) => Movie.fromJson(e)).toList();

    return movieList;
  }

  Future<List<MovieGenre>> fetchGenreList() async {
    dynamic response = await _genreService.getResponse(_getGenresUrl);
    final jsonData = response['genres'] as List;
    List<MovieGenre> movieGenreList =
        jsonData.map((e) => MovieGenre.fromJson(e)).toList();

    return movieGenreList;
  }

  Future<MovieDetail> fetchMovieDetails(int movieId) async {
    dynamic response = await _movieDetailService
        .getResponse(_getMovieDetailUrl + '/' + movieId.toString());

    MovieDetail movieDetail = MovieDetail.fromJson(response);

    return movieDetail;
  }
}
