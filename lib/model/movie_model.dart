class MovieModel {
  final double popularity;
  final int voteCount;
  final bool video;
  final String posterPath;
  final int id;
  final bool adult;
  final String backdropPath;
  final String originalLanguage;
  final String originalTitle;
  final List<int> genreIds;
  final String title;
  final double voteAverage;
  final String overview;
  final DateTime releaseDate;

  MovieModel({
    required this.popularity,
    required this.voteCount,
    required this.video,
    required this.posterPath,
    required this.id,
    required this.adult,
    required this.backdropPath,
    required this.originalLanguage,
    required this.originalTitle,
    required this.genreIds,
    required this.title,
    required this.voteAverage,
    required this.overview,
    required this.releaseDate,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        popularity: json["popularity"].toDouble(),
        voteCount: json["vote_count"],
        video: json["video"],
        posterPath: json["poster_path"] == null ? '' : json["poster_path"],
        id: json["id"],
        adult: json["adult"],
        backdropPath:
            json["backdrop_path"] == null ? '' : json["backdrop_path"],
        originalLanguage:
            json["original_language"] == null ? '' : json["original_language"],
        originalTitle:
            json["original_title"] == null ? '' : json["original_title"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        title: json["title"] == null ? '' : json["title"],
        voteAverage: json["vote_average"].toDouble(),
        overview: json["overview"] == null ? '' : json["overview"],
        releaseDate: DateTime.parse(json["release_date"]),
      );
}
