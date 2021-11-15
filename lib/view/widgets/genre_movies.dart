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
    await viewModel.fetchMoviesByGenre(widget.genreId);
    viewModel.apiResponse.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
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

    return ListView.builder(itemBuilder: (BuildContext context, int index) {
      // return Text(movieList[index].title);
      return MovieCardWidget(
        movie: movieList[index],
        movieGenres: viewModel.movieGenderPoster(movieList[index]),
      );
    });
  }
}
