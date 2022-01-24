import 'package:cubos_movies/model/movie_model.dart';

class MovieResponseModel {
  int page;
  final int totalResults;
  final int totalPages;
  final List<MovieModel> movies;

  MovieResponseModel({
    required this.page,
    required this.totalResults,
    required this.totalPages,
    required this.movies,
  });

  factory MovieResponseModel.fromJson(Map<String, dynamic> json) =>
      MovieResponseModel(
        page: json["page"],
        totalResults: json["total_results"],
        totalPages: json["total_pages"],
        movies: List<MovieModel>.from(
            json["results"].map((x) => MovieModel.fromJson(x))),
      );
}
