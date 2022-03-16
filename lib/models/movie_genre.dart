import 'dart:convert';

class MovieGenre {
  final int? id;
  final String? name;

  MovieGenre({
    this.id,
    this.name,
  });

  factory MovieGenre.fromJson(String str) =>
      MovieGenre.fromMap(json.decode(str));

  factory MovieGenre.fromMap(Map<String, dynamic> json) => MovieGenre(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'MovieGenre(id: $id, name: $name)';
}
