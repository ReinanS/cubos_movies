import 'package:cubos_movies/model/movie.dart';

class MovieResponse {
  int page;
  final int totalResults;
  final int totalPages;
  final List<Movie> movies;

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
        movies: List<Movie>.from(json["results"].map((x) => Movie.fromJson(x))),
      );
}
