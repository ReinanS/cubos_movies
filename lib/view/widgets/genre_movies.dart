import 'package:cubos_movies/model/movie_genre.dart';
import 'package:cubos_movies/model/movie.dart';
import 'package:cubos_movies/view/widgets/movie_card_widget.dart';
import 'package:flutter/material.dart';

class GenreMovies extends StatefulWidget {
  final int genreId;
  final List<Movie> movies;
  final List<MovieGenre> genres;

  GenreMovies({
    required this.genreId,
    required this.movies,
    required this.genres,
  });

  @override
  _GenreMoviesState createState() => _GenreMoviesState();
}

class _GenreMoviesState extends State<GenreMovies> {
  @override
  Widget build(BuildContext context) {
    return _buildGenreMovies();
  }

  Widget _buildGenreMovies() {
    List<Movie> movieList = widget.movies
        .where((movie) => movie.genreIds.contains(widget.genreId))
        .toList();

    return SingleChildScrollView(
      child: Column(
          children: movieList.map((movie) {
        return MovieCardWidget(
          movie: movie,
          movieGenres: movieGenderPoster(movie),
        );
        // return Text(movie.title);
      }).toList()),
    );

    // });
  }

  String movieGenderPoster(Movie movie) {
    String posterGenres = '';

    for (int index = 0; index < movie.genreIds.length; index++) {
      if (index == movie.genreIds.length - 1) {
        posterGenres += widget.genres
            .firstWhere((genre) => genre.id == movie.genreIds[index])
            .name;
      } else {
        posterGenres += widget.genres
                .firstWhere((genre) => genre.id == movie.genreIds[index])
                .name +
            ' - ';
      }
    }

    return posterGenres;
  }
}
