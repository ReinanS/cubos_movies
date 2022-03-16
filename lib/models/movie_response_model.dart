import 'dart:convert';

import 'movie_model.dart';

class MovieResponseModel {
  int? page;
  final int? totalResults;
  final int? totalPages;
  final List<MovieModel>? movies;

  MovieResponseModel({
    this.page,
    this.totalResults,
    this.totalPages,
    this.movies,
  });

  factory MovieResponseModel.fromJson(String str) =>
      MovieResponseModel.fromMap(json.decode(str));

  factory MovieResponseModel.fromMap(Map<String, dynamic> json) =>
      MovieResponseModel(
        page: json["page"],
        totalResults: json["total_results"],
        totalPages: json["total_pages"],
        movies: List<MovieModel>.from(
            json["results"].map((x) => MovieModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() {
    return {
      'page': page,
      'totalResults': totalResults,
      'totalPages': totalPages,
      'results': movies?.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());
}
