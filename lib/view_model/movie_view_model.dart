import 'package:cubos_movies/model/apis/api_response.dart';
import 'package:cubos_movies/model/genre.dart';
import 'package:cubos_movies/model/movie.dart';
import 'package:cubos_movies/model/repository/movie_repository.dart';
import 'package:flutter/cupertino.dart';

class MovieViewModel {
  final apiResponse =
      ValueNotifier<ApiResponse>(ApiResponse.initial('Empty data'));

  set response(ApiResponse response) => apiResponse.value = response;
  ApiResponse get response => apiResponse.value;

  // Movie? _movie;
  List<Movie>? _movieList;
  List<Genre>? _genres;

  final repository = MovieRepository();

  Future<void> fetchMovieData() async {
    response = ApiResponse.loading('Fetching movie data');

    try {
      _movieList = await repository.fetchMovieList();
      response = ApiResponse.completed(_movieList);
    } catch (e) {
      response = ApiResponse.error(e.toString());
      print(e);
    }
  }

  Future<void> fetchMovieDetailsData(int movieId) async {
    response = ApiResponse.loading('Fetching movie data');

    try {
      final movie = await repository.fetchMovieDetails(movieId);
      response = ApiResponse.completed(movie);
    } catch (e) {
      response = ApiResponse.error(e.toString());
      print(e);
    }
  }

  Future<void> fetchGenresList() async {
    response = ApiResponse.loading('Fetching movie data');

    try {
      _genres = await repository.fetchGenreList();
      response = ApiResponse.completed(_genres);
    } catch (e) {
      response = ApiResponse.error(e.toString());
      print(e);
    }
  }

  Future<void> fetchMoviesByGenre(int genreId) async {
    response = ApiResponse.loading('Fetching movie data');

    try {
      final movies = await repository.fetchMoviesByGenre(genreId);
      response = ApiResponse.completed(movies);
    } catch (e) {
      response = ApiResponse.error(e.toString());
      print(e);
    }
  }

  String movieGenderPoster(Movie movie) {
    String posterGenres = '';

    // for (int index = 0; index < movie.genreIds.length; index++) {
    //   if (index == movie.genreIds.length - 1) {
    //     posterGenres += _genres!
    //         .firstWhere((genre) => genre.id == movie.genreIds[index])
    //         .name;
    //   } else {
    //     posterGenres += _genres!
    //             .firstWhere((genre) => genre.id == movie.genreIds[index])
    //             .name +
    //         ' - ';
    //   }
    // }

    return posterGenres;
  }

  // void setSelectedMovie(Movie? movie) {
  //   _movie = movie;
  //   notifyListeners();
  // }
}
