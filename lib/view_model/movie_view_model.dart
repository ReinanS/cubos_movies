import 'package:cubos_movies/model/apis/api_response.dart';
import 'package:flutter/cupertino.dart';

class MovieViewModel {
  final _repository;

  MovieViewModel(this._repository);

  final apiResponse =
      ValueNotifier<ApiResponse>(ApiResponse.initial('Empty data'));

  set response(ApiResponse response) => apiResponse.value = response;
  ApiResponse get response => apiResponse.value;

  Future<void> fetchMovieData() async {
    response = ApiResponse.loading('Fetching movie data');

    try {
      final movies = await _repository.fetchMovieList();
      response = ApiResponse.completed(movies);
    } catch (e) {
      response = ApiResponse.error(e.toString());
      print(e);
    }
  }

  Future<void> fetchMovieDetailsData(int movieId) async {
    response = ApiResponse.loading('Fetching movie data');

    try {
      final movie = await _repository.fetchMovieDetails(movieId);
      response = ApiResponse.completed(movie);
    } catch (e) {
      response = ApiResponse.error(e.toString());
      print(e);
    }
  }

  Future<void> fetchGenresList() async {
    response = ApiResponse.loading('Fetching movie data');

    try {
      final genres = await _repository.fetchGenreList();
      response = ApiResponse.completed(genres);
    } catch (e) {
      response = ApiResponse.error(e.toString());
      print(e);
    }
  }
}
