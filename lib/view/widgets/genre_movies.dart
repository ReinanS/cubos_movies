import 'package:cubos_movies/model/apis/api_response.dart';
import 'package:cubos_movies/model/movie.dart';
import 'package:cubos_movies/view/widgets/movie_card_widget.dart';
import 'package:cubos_movies/view_model/movie_view_model.dart';
import 'package:flutter/material.dart';

class GenreMovies extends StatefulWidget {
  final int genreId;

  GenreMovies({required this.genreId});

  @override
  _GenreMoviesState createState() => _GenreMoviesState();
}

class _GenreMoviesState extends State<GenreMovies> {
  final MovieViewModel viewModel = MovieViewModel();

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    viewModel.fetchMoviesByGenre(widget.genreId);
    viewModel.apiResponse.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Text(widget.genreId.toString());

    ApiResponse apiResponse = viewModel.response;

    switch (apiResponse.status) {
      case Status.LOADING:
        {
          return Center(child: CircularProgressIndicator());
        }

      case Status.COMPLETED:
        return _buildGenreMovies(apiResponse);

      case Status.ERROR:
        return Center(
          child: Text('Please try again Later !!'),
        );

      case Status.INITIAL:
      default:
        return Center(
          child: Text('Search the Movie'),
        );
    }
  }

  Widget _buildGenreMovies(ApiResponse apiResponse) {
    List<Movie>? movieList = apiResponse.data as List<Movie>?;

    if (movieList!.length == 0) {
      return Center(
        child: Text('No Movies'),
      );
    }

    return SingleChildScrollView(
      child: Column(
          children: movieList.map((movie) {
        return MovieCardWidget(
          movie: movie,
          // movieGenres: viewModel.movieGenderPoster(movie),
        );
        // return Text(movie.title);
      }).toList()),
    );

    // });
  }
}
