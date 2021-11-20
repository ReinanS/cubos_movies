import 'dart:developer';

import 'package:cubos_movies/model/apis/api_response.dart';
import 'package:cubos_movies/model/movie.dart';
import 'package:cubos_movies/model/movie_genre.dart';
import 'package:cubos_movies/view/utils/utils.dart';
import 'package:cubos_movies/view/widgets/genres_tab_widget.dart';
import 'package:cubos_movies/view/widgets/search_bar_widget.dart';
import 'package:cubos_movies/view_model/movie_view_model.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovieViewModel movieViewModel = MovieViewModel();
  final MovieViewModel genreViewModel = MovieViewModel();

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    movieViewModel.fetchMovieData();
    movieViewModel.apiResponse.addListener(() {
      setState(() {});
    });

    genreViewModel.fetchGenresList();
    genreViewModel.apiResponse.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    ApiResponse apiMovieResponse = movieViewModel.response;
    ApiResponse apiGenreResponse = genreViewModel.response;

    Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: deviceSize * 0.25,
          child: Column(
            children: [
              AppBar(
                title: Text(
                  'Filmes',
                  style: TextStyle(color: Colors.black),
                ),
                toolbarHeight: 80,
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  child: SearchBarWidget(
                    labelText: 'Pesquise filmes',
                    controller: controller,
                    icon: Icon(
                      Icons.search,
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: _getGenres(apiMovieResponse, apiGenreResponse));
  }

  Widget _getGenres(
      ApiResponse apiMovieResponse, ApiResponse apiGenreResponse) {
    List<Movie>? movieList = apiMovieResponse.data as List<Movie>?;
    List<MovieGenre>? genreList = apiGenreResponse.data as List<MovieGenre>?;

    if ((apiGenreResponse.status == Status.LOADING) ||
        (apiMovieResponse.status == Status.LOADING)) {
      return Center(child: CircularProgressIndicator());
    }

    if ((apiGenreResponse.status == Status.COMPLETED) ||
        (apiMovieResponse.status == Status.COMPLETED)) {
      return GenresTabWidget(genres: genreList!, movies: movieList!);
    }

    if ((apiGenreResponse.status == Status.ERROR) ||
        (apiMovieResponse.status == Status.ERROR)) {
      return Center(child: Text('Please try again Later !!'));
    }

    return Center(child: Text('Search the Genres'));
  }
}
