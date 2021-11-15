class Movie {
  final int id;
  final String title;
  final String poster;
  final String overview;
  final List<int> genreIds;

  Movie({
    required this.id,
    required this.title,
    required this.poster,
    required this.overview,
    required this.genreIds,
  });

  Movie.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        poster = json["poster_path"],
        overview = json["overview"],
        genreIds = List.castFrom<dynamic, int>(json['genre_ids']);
}
