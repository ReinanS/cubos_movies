class MovieGenre {
  final int id;
  final String name;

  MovieGenre({
    required this.id,
    required this.name,
  });

  factory MovieGenre.fromJson(Map<String, dynamic> json) => MovieGenre(
        id: json["id"],
        name: json["name"],
      );
}
