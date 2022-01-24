import 'package:cubos_movies/model/apis/api_response.dart';
import 'package:cubos_movies/model/movie_genre.dart';
import 'package:cubos_movies/model/movie_model.dart';
import 'package:cubos_movies/model/repository/movie_repository.dart';
import 'package:cubos_movies/view/widgets/movie_card_widget.dart';
import 'package:cubos_movies/view_model/movie_view_model.dart';
import 'package:flutter/material.dart';

class GenreMovies extends StatefulWidget {
  final int genreId;
  final List<MovieGenre> genres;

  GenreMovies({
    required this.genreId,
    required this.genres,
  });

  @override
  _GenreMoviesState createState() => _GenreMoviesState();
}

class _GenreMoviesState extends State<GenreMovies> {
  final MovieViewModel movieViewModel = MovieViewModel(MovieRepository());

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    movieViewModel.fetchMovieByGenreData(genre: widget.genreId);
    movieViewModel.apiResponse.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildGenreMovies();
  }

  Widget _buildGenreMovies() {
    ApiResponse apiMovieResponse = movieViewModel.response;

    switch (apiMovieResponse.status) {
      case Status.COMPLETED:
        return _buildMovies(apiMovieResponse);
      case Status.ERROR:
        return Center(child: Text('Please try again Later !!'));

      case Status.INITIAL:
      case Status.LOADING:
      default:
        return Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildMovies(ApiResponse apiResponse) {
    List<MovieModel>? movieList = apiResponse.data as List<MovieModel>?;

    return SingleChildScrollView(
      child: Column(
        children: movieList!.map((movie) {
          return MovieCardWidget(
            movie: movie,
            movieGenres: movieGenderPoster(movie),
          );
        }).toList(),
      ),
    );
  }

  String movieGenderPoster(MovieModel movie) {
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
