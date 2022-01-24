import 'package:cubos_movies/model/movie_model.dart';

class MovieResponse {
  int page;
  final int totalResults;
  final int totalPages;
  final List<MovieModel> movies;

  MovieResponse({
    required this.page,
    required this.totalResults,
    required this.totalPages,
    required this.movies,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) => MovieResponse(
        page: json["page"],
        totalResults: json["total_results"],
        totalPages: json["total_pages"],
        movies: List<MovieModel>.from(
            json["results"].map((x) => MovieModel.fromJson(x))),
      );
}
