import 'dart:async';

import 'package:cubos_movies/model/apis/api_response.dart';
import 'package:cubos_movies/model/movie_model.dart';
import 'package:cubos_movies/model/movie_genre.dart';
import 'package:cubos_movies/model/movie_response_model.dart';
import 'package:cubos_movies/model/repository/movie_repository.dart';
import 'package:cubos_movies/view/utils/utils.dart';
import 'package:cubos_movies/view/widgets/genre_movies.dart';
import 'package:cubos_movies/view/widgets/movie_card_widget.dart';
import 'package:cubos_movies/view/widgets/search_bar_widget.dart';
import 'package:cubos_movies/view_model/movie_view_model.dart';
import 'package:flutter/material.dart';

class MovieSearchScreen extends StatefulWidget {
  final List<MovieGenre> genres;
  MovieSearchScreen({required this.genres});

  @override
  _MovieSearchScreenState createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  MovieRepository repository = MovieRepository();

  List<MovieModel> movies = [];
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(VoidCallback callback,
      {Duration duration = const Duration(milliseconds: 1000)}) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  init() async {
    final MovieResponseModel movies =
        await repository.fetchMoviesByName(query, 1);

    setState(() {
      this.movies = movies.movies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 30,
            color: AppColors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 15),
              child: SearchBarWidget(
                hintText: 'Pesquise filmes',
                onChanged: searchMovie,
              ),
            ),
            _buildMoviesResponse(),
          ],
        ),
      ),
    );
  }

  void searchMovie(String query) async => debounce(() async {
        final MovieResponseModel movies =
            await repository.fetchMoviesByName(query, 1);
        if (!mounted) return;

        setState(() {
          this.query = query;
          this.movies = movies.movies;
        });
      });

  Widget _buildMoviesResponse() {
    return Expanded(child: _buildMovies());

    // switch (apiMovieResponseModel.status) {
    //   case Status.LOADING:
    //     return Center(child: CircularProgressIndicator());

    //   case Status.COMPLETED:
    //     return Expanded(
    //       child: _buildMovies(apiMovieResponseModel),
    //     );

    //   case Status.ERROR:
    //     return Center(child: Text('Please try again Later !!'));

    //   case Status.INITIAL:
    //   default:
    //     return Center(child: Text('Search the Movies'));
    // }
  }

  Widget _buildMovies() {
    return SingleChildScrollView(
      child: Column(
        children: movies.map((movie) {
          // return Text(movie.title);
          return MovieCardWidget(
            movie: movie,
            movieGenres: movieGenderPoster(movie),
            // movieGenres: movieGenderPoster(movie),
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
